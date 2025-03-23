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
# 1. Load the Saved Model and Scaler
# ------------------------------
# Provide custom_objects for the 'mse' metric if needed.
custom_objects = {"mse": tf.keras.metrics.MeanSquaredError()}
model = load_model("./final_nn_model.h5", custom_objects=custom_objects)
print("Neural network model loaded successfully.")

# Load the pre-fitted scaler
scaler = joblib.load("Models/scaler.pkl")
print("Scaler loaded successfully.")

# ------------------------------
# 2. Load and Preprocess the Dataset
# ------------------------------
df = pd.read_csv("irrigation_dataset.csv")

# Count the number of cases where WATER REQUIREMENT > 100
num_cases_above_100 = (df["WATER REQUIREMENT"] > 100).sum()
print("Number of cases where WATER REQUIREMENT > 100:", num_cases_above_100)

# Remove cases where WATER REQUIREMENT > 100
df_filtered = df[df["WATER REQUIREMENT"] <= 100]
print("Total cases after filtering:", len(df_filtered))

# ------------------------------
# 3. Preprocess the Filtered Dataset
# ------------------------------
# Separate features and target
X = df_filtered.drop("WATER REQUIREMENT", axis=1)
y = df_filtered["WATER REQUIREMENT"]

# One-hot encode categorical features
X_encoded = pd.get_dummies(X, drop_first=False)

# *** NEW CODE: Reindex to match training columns ***
training_columns = joblib.load("Models/training_columns.pkl")
X_encoded = X_encoded.reindex(columns=training_columns, fill_value=0)

# Standardize features using the loaded scaler
X_scaled = scaler.transform(X_encoded)

# (Optional) Inspect the target distribution
plt.figure(figsize=(8,6))
sns.histplot(y, kde=True, bins=30)
plt.title("Original Target Distribution (Filtered Data)")
plt.xlabel("WATER REQUIREMENT")
plt.ylabel("Frequency")
plt.show()

# ------------------------------
# 4. (If needed) Create a Train/Test Split
# ------------------------------
# Here we evaluate on the entire filtered dataset.
# If you wish to create a test set, uncomment the splitting below:
# X_train, X_test, y_train, y_test = train_test_split(
#     X_scaled, y, test_size=0.2, random_state=42
# )
# For evaluation on the entire dataset, we use:
X_test = X_scaled
y_test = y

# ------------------------------
# 5. Make Predictions and Evaluate
# ------------------------------
# The model was trained on the log-transformed target, so predictions are in log scale.
y_pred_log = model.predict(X_test).flatten()

# Convert predictions back to original scale
y_pred = np.expm1(y_pred_log)

# Compute evaluation metrics on original scale
mse_val = mean_squared_error(y_test, y_pred)
rmse_val = np.sqrt(mse_val)
r2_val = r2_score(y_test, y_pred)
accuracy_percentage = r2_val * 100

print("\nTesting Evaluation Metrics on Filtered Data:")
print("Mean Squared Error:", mse_val)
print("Root Mean Squared Error:", rmse_val)
print("R² Score:", r2_val)
print("Accuracy (%):", accuracy_percentage)

# ------------------------------
# 6. Plot Actual vs. Predicted Values (Optional)
# ------------------------------
plt.figure(figsize=(8,6))
sns.scatterplot(x=y_test, y=y_pred, alpha=0.6)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--')
plt.xlabel("Actual WATER REQUIREMENT")
plt.ylabel("Predicted WATER REQUIREMENT")
plt.title("Actual vs. Predicted WATER REQUIREMENT (Filtered Data)")
plt.show()
