import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D, Dropout, Input, BatchNormalization, Activation, Lambda
from tensorflow.keras.layers import Concatenate, Reshape, Multiply, Add, Conv2D
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input as mobilenet_preprocess
from tensorflow.keras.callbacks import ModelCheckpoint, EarlyStopping, ReduceLROnPlateau, TensorBoard



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