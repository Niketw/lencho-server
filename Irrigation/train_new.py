import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, BatchNormalization
from tensorflow.keras.callbacks import EarlyStopping
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.preprocessing import StandardScaler
import joblib  # <-- Added to save training columns

# ------------------------------
# Check GPU Availability and Set Memory Growth
# ------------------------------
physical_devices = tf.config.list_physical_devices('GPU')
if physical_devices:
    for device in physical_devices:
        try:
            tf.config.experimental.set_memory_growth(device, True)
        except RuntimeError as e:
            print("Memory growth not set because the GPU is already initialized:", e)
else:
    print("No GPU found. Using CPU.")

# ------------------------------
# 1. Data Loading & Exploration
# ------------------------------
df = pd.read_csv("irrigation_dataset.csv")

print("Head of the dataset:")
print(df.head())
print("\nDataset Info:")
print(df.info())
print("\nStatistical Summary:")
print(df.describe())
print("\nMissing Values in Each Column:")
print(df.isnull().sum())

plt.figure(figsize=(8,6))
sns.histplot(df["WATER REQUIREMENT"], kde=True, bins=30)
plt.title("Distribution of Water Requirement (mm)")
plt.xlabel("Water Requirement (mm)")
plt.ylabel("Frequency")
plt.show()

categorical_features = ['CROP TYPE', 'SOIL TYPE', 'REGION', 'WEATHER CONDITION']
for col in categorical_features:
    plt.figure(figsize=(8,6))
    sns.countplot(y=col, data=df, order=df[col].value_counts().index)
    plt.title(f"Count Plot of {col}")
    plt.xlabel("Count")
    plt.ylabel(col)
    plt.show()

for col in categorical_features:
    plt.figure(figsize=(8,6))
    sns.boxplot(x=col, y="WATER REQUIREMENT", data=df)
    plt.title(f"Water Requirement by {col}")
    plt.xlabel(col)
    plt.ylabel("Water Requirement (mm)")
    plt.show()

# ------------------------------
# 2. Preprocessing: Feature Engineering, Target Transformation & Splitting
# ------------------------------
# Separate features and target
X = df.drop("WATER REQUIREMENT", axis=1)
y = df["WATER REQUIREMENT"]

# One-hot encode categorical features
X_encoded = pd.get_dummies(X, drop_first=False)

# *** NEW CODE: Save the training columns (one-hot encoded feature names) ***
training_columns = X_encoded.columns.tolist()
joblib.dump(training_columns, "Models/training_columns.pkl")
print("Training columns saved as 'training_columns.pkl'.")

# Standardize features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_encoded)

# Optionally, inspect the distribution of y
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

# Split the data (80% training, 20% testing)
X_train, X_test, y_train_log, y_test_log = train_test_split(
    X_scaled, y_log, test_size=0.2, random_state=42
)

# We'll keep the original y_test (untransformed) for evaluation later.
_, _, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

# ------------------------------
# 3. Build and Train the Neural Network (Using GPU)
# ------------------------------
# Build a neural network architecture tailored for the log-transformed target
model = Sequential()
model.add(Dense(128, input_dim=X_train.shape[1], activation='relu'))
model.add(BatchNormalization())
model.add(Dropout(0.2))
model.add(Dense(64, activation='relu'))
model.add(BatchNormalization())
model.add(Dropout(0.2))
model.add(Dense(32, activation='relu'))
model.add(BatchNormalization())
model.add(Dense(1, activation='linear'))  # Regression output

# Compile the model with Adam optimizer and a low learning rate
optimizer = tf.keras.optimizers.Adam(learning_rate=0.001)
model.compile(optimizer=optimizer, loss='mse', metrics=['mse'])

# Early stopping callback
early_stop = EarlyStopping(monitor='val_loss', patience=20, restore_best_weights=True)

# Train the model using the log-transformed target
history = model.fit(
    X_train, y_train_log,
    validation_split=0.2,
    epochs=300,
    batch_size=32,
    callbacks=[early_stop],
    verbose=1
)

# ------------------------------
# 4. Evaluate the Model
# ------------------------------
# Make predictions on the test set (in log scale)
y_pred_log = model.predict(X_test).flatten()
# Transform predictions back to original scale
y_pred = np.expm1(y_pred_log)

# Compute evaluation metrics on original scale
mse_val = mean_squared_error(y_test, y_pred)
rmse_val = np.sqrt(mse_val)
r2_val = r2_score(y_test, y_pred)
accuracy_percentage = r2_val * 100

print("\nNeural Network Model Evaluation (After Target Transformation):")
print("Mean Squared Error:", mse_val)
print("Root Mean Squared Error:", rmse_val)
print("R² Score:", r2_val)
print("Accuracy (%):", accuracy_percentage)

# ------------------------------
# 5. Save the Model as H5
# ------------------------------
model.save("final_nn_model.h5")
print("\nNeural network model saved as 'final_nn_model.h5'.")
