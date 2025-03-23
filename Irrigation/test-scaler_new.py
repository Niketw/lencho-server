import pandas as pd
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import load_model
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score
import joblib
import matplotlib.pyplot as plt
import seaborn as sns

# ------------------------------
# 1. Load the Saved Model
# ------------------------------
# Provide custom_objects for the 'mse' metric if needed.
custom_objects = {"mse": tf.keras.metrics.MeanSquaredError()}
model = load_model("./final_nn_model.h5", custom_objects=custom_objects)
print("Neural network model loaded successfully.")

# ------------------------------
# 2. Load and Preprocess the Dataset
# ------------------------------
df = pd.read_csv("irrigation_dataset.csv")

# Separate features and target
X = df.drop("WATER REQUIREMENT", axis=1)
y = df["WATER REQUIREMENT"]

# One-hot encode categorical features
X_encoded = pd.get_dummies(X, drop_first=False)

# *** NEW: Reindex the encoded DataFrame to match the training columns ***
training_columns = joblib.load("Models/training_columns.pkl")
X_encoded = X_encoded.reindex(columns=training_columns, fill_value=0)

# Standardize features using a new StandardScaler instance
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_encoded)

# Save the scaler so that it can be reused for future data
joblib.dump(scaler, "Models/scaler.pkl")
print("Scaler saved as 'scaler.pkl'.")

# Optionally, inspect the original target distribution
plt.figure(figsize=(8,6))
sns.histplot(y, kde=True, bins=30)
plt.title("Original Target Distribution")
plt.xlabel("WATER REQUIREMENT")
plt.ylabel("Frequency")
plt.show()

# Transform the target using a log transformation to reduce skewness
y_log = np.log1p(y)

plt.figure(figsize=(8,6))
sns.histplot(y_log, kde=True, bins=30)
plt.title("Log-Transformed Target Distribution")
plt.xlabel("log1p(WATER REQUIREMENT)")
plt.ylabel("Frequency")
plt.show()

# ------------------------------
# 3. Create Train/Test Splits (Using the same random_state as training)
# ------------------------------
# Split the preprocessed features and log-transformed target into training and test sets
X_train, X_test, y_train_log, y_test_log = train_test_split(
    X_scaled, y_log, test_size=0.2, random_state=42
)

# Also, split to get the original y for evaluation after inverse transformation
_, _, _, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=42
)

# ------------------------------
# 4. Make Predictions and Evaluate
# ------------------------------
# Predict on the test set (predictions are in log scale)
y_pred_log = model.predict(X_test).flatten()

# Reverse the log transformation to get predictions in the original scale
y_pred = np.expm1(y_pred_log)

# Compute evaluation metrics on original scale
mse_val = mean_squared_error(y_test, y_pred)
rmse_val = np.sqrt(mse_val)
r2_val = r2_score(y_test, y_pred)
accuracy_percentage = r2_val * 100

print("\nTesting Evaluation Metrics:")
print("Mean Squared Error:", mse_val)
print("Root Mean Squared Error:", rmse_val)
print("R² Score:", r2_val)
print("Accuracy (%):", accuracy_percentage)

# ------------------------------
# 5. Plot Actual vs. Predicted Values (Optional)
# ------------------------------
plt.figure(figsize=(8,6))
sns.scatterplot(x=y_test, y=y_pred, alpha=0.6)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--')
plt.xlabel("Actual WATER REQUIREMENT")
plt.ylabel("Predicted WATER REQUIREMENT")
plt.title("Actual vs. Predicted WATER REQUIREMENT")
plt.show()

# Save the fitted scaler to a file called "scaler.pkl" (again, to ensure persistence)
joblib.dump(scaler, "Models/scaler.pkl")
print("Scaler saved as 'scaler.pkl'.")
