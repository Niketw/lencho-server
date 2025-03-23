import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout, Input, BatchNormalization, Activation, Lambda
from tensorflow.keras.layers import Concatenate, Reshape, Multiply, Add, Conv2D
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input as mobilenet_preprocess
from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau, TensorBoard
import matplotlib.pyplot as plt
import cv2
import datetime

# -----------------------------
# Configuration
# -----------------------------
DATA_DIR = "Datasets/Mango"  # Base directory with class subfolders
IMG_SIZE = (224, 224)        # MobileNetV2 standard input size
BATCH_SIZE = 32
EPOCHS = 30
LEARNING_RATE = 0.0001
MODEL_PATH = "Models/Mango/Mango_disease.keras"
SEED = 69

# -----------------------------
# Custom CBAM Layer
# -----------------------------
@tf.keras.utils.register_keras_serializable()
class CBAM(tf.keras.layers.Layer):
    def __init__(self, reduction_ratio=16, **kwargs):
        super(CBAM, self).__init__(**kwargs)
        self.reduction_ratio = reduction_ratio

    def build(self, input_shape):
        channel = int(input_shape[-1])
        # Channel attention: shared dense layers
        self.shared_dense_one = Dense(channel // self.reduction_ratio,
                                      activation='relu',
                                      kernel_initializer='he_normal',
                                      use_bias=True,
                                      bias_initializer='zeros')
        self.shared_dense_two = Dense(channel,
                                      kernel_initializer='he_normal',
                                      use_bias=True,
                                      bias_initializer='zeros')
        # Spatial attention: single convolution with kernel size 7
        self.conv_spatial = Conv2D(1, kernel_size=7, padding='same',
                                   activation='sigmoid', kernel_initializer='he_normal')
        super(CBAM, self).build(input_shape)

    def call(self, input_tensor):
        # --- Channel Attention ---
        avg_pool = tf.keras.layers.GlobalAveragePooling2D()(input_tensor)
        avg_pool = Reshape((1, 1, int(input_tensor.shape[-1])))(avg_pool)
        avg_pool = self.shared_dense_one(avg_pool)
        avg_pool = self.shared_dense_two(avg_pool)

        max_pool = tf.keras.layers.GlobalMaxPooling2D()(input_tensor)
        max_pool = Reshape((1, 1, int(input_tensor.shape[-1])))(max_pool)
        max_pool = self.shared_dense_one(max_pool)
        max_pool = self.shared_dense_two(max_pool)

        channel_attention = Add()([avg_pool, max_pool])
        channel_attention = Activation('sigmoid')(channel_attention)
        channel_refined = Multiply()([input_tensor, channel_attention])

        # --- Spatial Attention using Single Convolution ---
        avg_pool_spatial = tf.reduce_mean(channel_refined, axis=-1, keepdims=True)
        max_pool_spatial = tf.reduce_max(channel_refined, axis=-1, keepdims=True)
        concat = Concatenate(axis=-1)([avg_pool_spatial, max_pool_spatial])
        spatial_attention = self.conv_spatial(concat)

        refined_feature = Multiply()([channel_refined, spatial_attention])
        return refined_feature

# Set the module name so that CBAM can be properly deserialized
CBAM.__module__ = "CustomLayers"

# -----------------------------
# Grad-CAM Callback
# -----------------------------
class GradCAMCallback(tf.keras.callbacks.Callback):
    """
    At the end of each epoch, this callback computes Grad-CAM heatmaps for a given set of sample images.
    The heatmaps are overlayed on the original images and saved to disk.
    """
    def __init__(self, sample_images, last_conv_layer_name, output_dir="gradcam_results"):
        super().__init__()
        self.sample_images = sample_images  # Array of preprocessed sample images (values in [0,1])
        self.last_conv_layer_name = last_conv_layer_name
        self.output_dir = output_dir
        if not os.path.exists(self.output_dir):
            os.makedirs(self.output_dir)

    def on_epoch_end(self, epoch, logs=None):
        epoch_dir = os.path.join(self.output_dir, f"epoch_{epoch + 1}")
        if not os.path.exists(epoch_dir):
            os.makedirs(epoch_dir)

        for idx, image in enumerate(self.sample_images):
            input_image = np.expand_dims(image, axis=0)
            heatmap = self.compute_gradcam(input_image)
            heatmap_resized = cv2.resize(heatmap, (IMG_SIZE[1], IMG_SIZE[0]))
            heatmap_resized = np.uint8(255 * heatmap_resized)
            heatmap_color = cv2.applyColorMap(heatmap_resized, cv2.COLORMAP_JET)
            orig_img = np.uint8(image * 255)
            superimposed_img = cv2.addWeighted(orig_img, 0.6, heatmap_color, 0.4, 0)
            out_path = os.path.join(epoch_dir, f"gradcam_sample_{idx}.jpg")
            cv2.imwrite(out_path, superimposed_img)
            print(f"Saved Grad-CAM overlay to {out_path}")

    def compute_gradcam(self, image):
        # Create a model mapping the input image to the activations of the last conv layer and predictions.
        grad_model = tf.keras.models.Model(
            [self.model.inputs],
            [self.model.get_layer(self.last_conv_layer_name).output, self.model.output]
        )
        with tf.GradientTape() as tape:
            conv_outputs, predictions = grad_model(image)
            pred_index = tf.argmax(predictions[0])
            loss = predictions[:, pred_index]
        grads = tape.gradient(loss, conv_outputs)
        pooled_grads = tf.reduce_mean(grads, axis=(0, 1, 2))
        conv_outputs = conv_outputs[0]
        heatmap = tf.reduce_sum(tf.multiply(pooled_grads, conv_outputs), axis=-1)
        heatmap = tf.maximum(heatmap, 0) / (tf.reduce_max(heatmap) + 1e-8)
        return heatmap.numpy()

# -----------------------------
# Helper: Select the 25th Image from Each Class for Grad-CAM
# -----------------------------
def get_gradcam_samples(num_classes):
    gradcam_files = []
    class_dirs = sorted([d for d in os.listdir(DATA_DIR) if os.path.isdir(os.path.join(DATA_DIR, d))])
    class_indices = {cls: idx for idx, cls in enumerate(class_dirs)}

    for cls in class_dirs:
        cls_path = os.path.join(DATA_DIR, cls)
        files = sorted([f for f in os.listdir(cls_path) if f.lower().endswith(('.jpg', '.jpeg', '.png'))])
        if len(files) >= 225:
            # Select the 25th image (index 24)
            gradcam_files.append((os.path.join(cls_path, files[224]), class_indices[cls]))
        else:
            print(f"Class {cls} does not have 25 images.")

    X_grad, y_grad = [], []
    for file_path, class_idx in gradcam_files:
        img = cv2.imread(file_path)
        if img is None:
            continue
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = cv2.resize(img, IMG_SIZE)
        img = img / 255.0
        X_grad.append(img)
        label = np.zeros(num_classes)
        label[class_idx] = 1
        y_grad.append(label)
    X_grad = np.array(X_grad)
    y_grad = np.array(y_grad)
    print(f"Grad-CAM samples shape: {X_grad.shape}, Labels shape: {y_grad.shape}")
    return X_grad, y_grad

# -----------------------------
# Dataset Creation using tf.data
# -----------------------------
def create_datasets():
    train_ds = tf.keras.utils.image_dataset_from_directory(
        DATA_DIR,
        validation_split=0.2,
        subset="training",
        seed=SEED,
        image_size=IMG_SIZE,
        batch_size=BATCH_SIZE,
        label_mode="categorical"
    )

    val_ds = tf.keras.utils.image_dataset_from_directory(
        DATA_DIR,
        validation_split=0.2,
        subset="validation",
        seed=SEED,
        image_size=IMG_SIZE,
        batch_size=BATCH_SIZE,
        label_mode="categorical"
    )

    class_names = train_ds.class_names
    num_classes = len(class_names)
    print(f"Found {num_classes} classes: {class_names}")

    data_augmentation = tf.keras.Sequential([
        tf.keras.layers.RandomFlip("horizontal"),
        tf.keras.layers.RandomRotation(0.1),
        tf.keras.layers.RandomZoom(0.1)
    ])

    def preprocess(image, label):
        image = mobilenet_preprocess(image)
        return image, label

    AUTOTUNE = tf.data.AUTOTUNE
    train_ds = train_ds.map(preprocess, num_parallel_calls=AUTOTUNE)
    val_ds = val_ds.map(preprocess, num_parallel_calls=AUTOTUNE)
    train_ds = train_ds.unbatch().batch(BATCH_SIZE, drop_remainder=True).prefetch(buffer_size=AUTOTUNE)
    val_ds = val_ds.unbatch().batch(BATCH_SIZE, drop_remainder=True).prefetch(buffer_size=AUTOTUNE)

    return train_ds, val_ds, num_classes, class_names

# -----------------------------
# Model Creation using MobileNetV2 and CBAM
# -----------------------------
def create_model(num_classes):
    inputs = Input(shape=(IMG_SIZE[0], IMG_SIZE[1], 3))

    base_model = MobileNetV2(weights='imagenet', include_top=False,
                              input_tensor=inputs)
    base_model.trainable = False

    x = base_model.output
    # Apply CBAM attention
    x = CBAM(reduction_ratio=16, name="cbam")(x)

    x = GlobalAveragePooling2D()(x)
    x = Dropout(0.5)(x)
    x = Dense(128, activation='relu')(x)
    x = Dropout(0.3)(x)
    x = Dense(64, activation='relu')(x)
    outputs = Dense(num_classes, activation='softmax')(x)

    model = Model(inputs=inputs, outputs=outputs)
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=LEARNING_RATE),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )
    return model, base_model

# -----------------------------
# Training Function (Fine-Tuning on Full Dataset)
# -----------------------------
def train_model_fn(model, base_model, train_ds, val_ds, gradcam_samples):
    checkpoint = ModelCheckpoint(
        MODEL_PATH,
        monitor='val_accuracy',
        save_best_only=True,
        mode='max',
        verbose=1
    )
    early_stopping = EarlyStopping(
        monitor='val_loss',
        patience=3,
        restore_best_weights=True,
        verbose=1
    )
    reduce_lr = ReduceLROnPlateau(
        monitor='val_loss',
        factor=0.2,
        patience=5,
        min_lr=1e-6,
        verbose=1
    )
    log_dir = "logs/fit/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    tensorboard_callback = TensorBoard(log_dir=log_dir, histogram_freq=1)

    # Grad-CAM callback for the 25th image in each class
    gradcam_callback = GradCAMCallback(sample_images=gradcam_samples, last_conv_layer_name="cbam")

    callbacks = [checkpoint, early_stopping, reduce_lr, tensorboard_callback, gradcam_callback]

    # Fine-tuning: unfreeze the last 11 layers of the base model
    for layer in base_model.layers[-11:]:
        layer.trainable = True

    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=LEARNING_RATE),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )

    history = model.fit(
        train_ds,
        epochs=EPOCHS,
        validation_data=val_ds,
        callbacks=callbacks
    )
    return history

# -----------------------------
# Evaluation & Visualization
# -----------------------------
def evaluate_model_fn(model, val_ds):
    print("Evaluating model...")
    loss, accuracy = model.evaluate(val_ds)
    print(f"Validation Loss: {loss:.4f}, Validation Accuracy: {accuracy:.4f}")
    return loss, accuracy

def visualize_results(history):
    plt.figure(figsize=(12, 4))
    plt.subplot(1, 2, 1)
    plt.plot(history.history['accuracy'], label='Train')
    plt.plot(history.history['val_accuracy'], label='Val')
    plt.title('Model Accuracy')
    plt.xlabel('Epoch')
    plt.ylabel('Accuracy')
    plt.legend()

    plt.subplot(1, 2, 2)
    plt.plot(history.history['loss'], label='Train')
    plt.plot(history.history['val_loss'], label='Val')
    plt.title('Model Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.legend()

    plt.tight_layout()
    plt.savefig('training_results.png')

# -----------------------------
# Main Function
# -----------------------------
def main():
    np.random.seed(SEED)
    tf.random.set_seed(SEED)

    train_ds, val_ds, num_classes, class_names = create_datasets()

    # Obtain the Grad-CAM samples (25th image from each class)
    gradcam_samples, _ = get_gradcam_samples(num_classes)

    model, base_model = create_model(num_classes)
    model.summary()

    history = train_model_fn(model, base_model, train_ds, val_ds, gradcam_samples)
    evaluate_model_fn(model, val_ds)
    visualize_results(history)

    model.save(MODEL_PATH, save_format='keras')
    print(f"Model saved to {MODEL_PATH}") 

if __name__ == "__main__":
    main()

# mobilenet v2 + cbam + dense(256) --- 0.9987
# mobilenet v2 + cbam + dense(128) --- 1
# mobilenet v2 + cbam + dense(32) --- 1