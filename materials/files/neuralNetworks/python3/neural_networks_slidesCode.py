"""
Neural Networks: Python code from neural_networks_slides slides. You can use this code to run your experiments in Python. The code is al available in the slides.

Setup: the project folder should already have a pyproject.toml file to be used with UV (https://uv.run). All packages are listed in the pyproject.toml file, so you can install them with `uv sync` or `uv run`. If you don't want to use UV, you can install the packages manually with pip.

All necessary packages have been included with this code (e.g., `tensorflow keras
scikit-learn matplotlib pandas numpy`). 
Note: `uv sync` installs the packages; `uv run`
also installs them automatically when running the code. If you don't want to use uv, you can install the packages manually with pip.
  Without uv:
    pip install tensorflow keras scikit-learn matplotlib pandas numpy

Run (from the root folder):
    uv run python src/neural_networks_slidesCode.py
Note: Each "# %%" marks a slide, so VS Code / Spyder can run it cell by cell.
"""

# %% XOR in Python (Part 1): Using Keras/TensorFlow
import numpy as np
from tensorflow import keras
from tensorflow.keras import layers
import matplotlib.pyplot as plt

# Create XOR dataset
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])

print("XOR Training Data:")
print("Inputs:\n", X)
print("Outputs:\n", y)

# %% XOR in Python (Part 2): Building the Model
# Build neural network
np.random.seed(123)

model = keras.Sequential([
    layers.Dense(2, activation='sigmoid', input_shape=(2,)),  # Hidden layer
    layers.Dense(1, activation='sigmoid')                      # Output layer
])

# Compile model
model.compile(
    optimizer='adam',
    loss='binary_crossentropy',
    metrics=['accuracy']
)

# Display model architecture
print("\nModel Architecture:")
model.summary()

# %% XOR in Python (Part 3): Training the Model
# Train the network
history = model.fit(
    X, y,
    epochs=1000,
    verbose=0  # Suppress output
)

# Display training results
print("\nFinal Training Loss:", history.history['loss'][-1])
print("Final Training Accuracy:", history.history['accuracy'][-1])

# Plot training history
plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot(history.history['loss'])
plt.title('Model Loss Over Time')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(history.history['accuracy'])
plt.title('Model Accuracy Over Time')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.grid(True)

plt.tight_layout()
plt.show()

# %% XOR in Python (Part 4): Making Predictions
# Test the network
predictions = model.predict(X)

# Display results
print("\nPredictions:")
for i in range(len(X)):
    print(f"Input: {X[i]} | Actual: {y[i][0]} | Predicted: {predictions[i][0]:.3f} | Binary: {round(predictions[i][0])}")

# Calculate accuracy
binary_predictions = np.round(predictions)
accuracy = np.mean(binary_predictions == y)
print(f"\nAccuracy: {accuracy * 100}%")

# %% Iris Classification (Python): Data Preparation
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np
import pandas as pd

# Load iris dataset
iris = load_iris()
X = iris.data
y = iris.target

# Normalize features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=123
)

print("Training samples:", len(X_train))
print("Testing samples:", len(X_test))
print("Features:", iris.feature_names)
print("Classes:", iris.target_names)

# %% Building Iris Model (Python)
# Build neural network
model = keras.Sequential([
    layers.Dense(5, activation='relu', input_shape=(4,)),  # Hidden layer 1
    layers.Dense(3, activation='relu'),                     # Hidden layer 2
    layers.Dense(3, activation='softmax')                   # Output layer
])

# Compile model
model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# Display architecture
print("\nModel Architecture:")
model.summary()

# %% Training Iris Model (Python)
# Train the model
history = model.fit(
    X_train, y_train,
    epochs=100,
    batch_size=16,
    validation_split=0.2,  # Use 20% of training for validation
    verbose=0
)

# Plot training history
plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Model Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(history.history['accuracy'], label='Training Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.title('Model Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()

# %% Iris Predictions (Python)
# Evaluate on test set
test_loss, test_accuracy = model.evaluate(X_test, y_test, verbose=0)
print(f"\nTest Loss: {test_loss:.4f}")
print(f"Test Accuracy: {test_accuracy * 100:.2f}%")

# Make predictions
predictions = model.predict(X_test)
predicted_classes = np.argmax(predictions, axis=1)

# Display sample results
print("\nSample Predictions:")
for i in range(10):
    print(f"Actual: {iris.target_names[y_test[i]]:12} | "
          f"Predicted: {iris.target_names[predicted_classes[i]]:12} | "
          f"Probabilities: {predictions[i]}")

# Confusion matrix
from sklearn.metrics import confusion_matrix, classification_report
print("\nConfusion Matrix:")
print(confusion_matrix(y_test, predicted_classes))

print("\nClassification Report:")
print(classification_report(y_test, predicted_classes,
                           target_names=iris.target_names))
