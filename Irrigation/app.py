from flask import Flask, request, render_template, jsonify
import joblib
from irrigation import predict_water_requirement

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def home():
    prediction = None
    error = None
    if request.method == 'POST':
        try:
            # Create a dictionary from form input values
            data = {
                "CROP TYPE": request.form.get('crop_type'),
                "SOIL TYPE": request.form.get('soil_type'),
                "REGION": request.form.get('region'),
                "TEMPERATURE": request.form.get('temperature'),
                "WEATHER CONDITION": request.form.get('weather_condition')
            }
            # Call the ML model function
            prediction = predict_water_requirement(data)
        except Exception as e:
            error = str(e)
    return render_template('index.html', prediction=prediction, error=error)

@app.route('/predict_irrigation', methods=['POST'])
def predict_irrigation():
    try:
        # Expect JSON input containing the required keys
        data = request.get_json(force=True)
        prediction = predict_water_requirement(data)
        return jsonify({"predicted_water_requirement": prediction})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    # Run the Flask app on port 8080
    app.run(host='0.0.0.0', port=8080, debug=True)
