from flask import Flask, request, render_template, jsonify
import os
import cv2
import numpy as np
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input as mobilenet_preprocess
from tensorflow.keras.models import load_model

# Import the CBAM layer from your training module
from cbam import CBAM

# -----------------------------
# Configuration
# -----------------------------
MODEL_DIR = "Models/Mango"
MODEL_PATH = os.path.join(MODEL_DIR, "Mango_disease.keras")
CLASSES_FILE = os.path.join(MODEL_DIR, "classes.txt")
IMG_SIZE = (224, 224)  # MobileNetV2 input size


# Load class names from the file
def load_classes(file_path):
    try:
        with open(file_path, "r") as f:
            class_list = f.read().strip().split(", ")
            return [cls.strip().strip("'") for cls in class_list]  # Remove quotes and whitespace
    except Exception as e:
        print(f"Error loading class names: {e}")
        return []


CLASSES = load_classes(CLASSES_FILE)
print(f"Loaded classes: {CLASSES}")

app = Flask(__name__)

# Load the model with custom objects (CBAM)
custom_objects = {"CBAM": CBAM}
model = load_model(MODEL_PATH, custom_objects=custom_objects)
print("Model loaded successfully.")


@app.route('/', methods=['GET', 'POST'])
def home():
    prediction = None
    error = None
    if request.method == 'POST':
        if 'image' not in request.files:
            error = "No file uploaded."
        else:
            file = request.files['image']
            if file.filename == '':
                error = "No file selected."
            else:
                try:
                    # Read image file into a numpy array
                    file_bytes = file.read()
                    np_arr = np.frombuffer(file_bytes, np.uint8)
                    img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
                    if img is None:
                        error = "Invalid image format."
                    else:
                        # Process the image: convert, resize, and preprocess
                        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
                        img_resized = cv2.resize(img_rgb, IMG_SIZE)
                        img_preprocessed = mobilenet_preprocess(img_resized.astype(np.float32))
                        input_img = np.expand_dims(img_preprocessed, axis=0)

                        # Run prediction on the image
                        preds = model.predict(input_img)
                        pred_index = int(np.argmax(preds[0]))
                        predicted_class = CLASSES[pred_index]
                        confidence = preds[0][pred_index]

                        prediction = f"{predicted_class} (Confidence: {confidence:.2f})"
                except Exception as e:
                    error = str(e)
    return render_template('index.html', prediction=prediction, error=error)


# New API endpoint for JSON inference
@app.route('/predict-image', methods=['POST'])
def predict_image():
    try:
        if 'image' not in request.files:
            return jsonify({"error": "No file provided"}), 400
        file = request.files['image']
        if file.filename == '':
            return jsonify({"error": "No file selected"}), 400

        file_bytes = file.read()
        np_arr = np.frombuffer(file_bytes, np.uint8)
        img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
        if img is None:
            return jsonify({"error": "Invalid image format"}), 400

        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img_resized = cv2.resize(img_rgb, IMG_SIZE)
        img_preprocessed = mobilenet_preprocess(img_resized.astype(np.float32))
        input_img = np.expand_dims(img_preprocessed, axis=0)

        preds = model.predict(input_img)
        pred_index = int(np.argmax(preds[0]))
        predicted_class = CLASSES[pred_index]
        confidence = preds[0][pred_index]

        return jsonify({
            "predicted_class": predicted_class,
            "confidence": float(confidence)
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 400


if __name__ == '__main__':
    # For Hugging Face Spaces, listen on port 7860
    app.run(host='0.0.0.0', port=7860, debug=True)
