import pandas as pd
import numpy as np
import os
from sklearn.model_selection import train_test_split
import xgboost as xgb
import joblib

# Load dataset from environment or local test
input_file = os.environ.get('INPUT_CSV', 'synthetic_fraud_dataset.csv')
df = pd.read_csv(input_file)

# Ensure label exists
assert 'Fraud_Label' in df.columns, "Fraud_Label column is missing."

# Features and label
X = df.drop(columns=['Fraud_Label'])
y = df['Fraud_Label']

# Stratified split
X_train, X_val, y_train, y_val = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# Train XGBoost model
model = xgb.XGBClassifier(
    objective='binary:logistic',
    eval_metric='auc',
    use_label_encoder=False,
    n_estimators=100,
    max_depth=5
)

model.fit(
    X_train,
    y_train,
    eval_set=[(X_val, y_val)],
    early_stopping_rounds=10,
    verbose=True
)

# Save model
output_dir = os.environ.get('MODEL_DIR', 'output')
os.makedirs(output_dir, exist_ok=True)
model_path = os.path.join(output_dir, 'xgboost_model.joblib')
joblib.dump(model, model_path)

print(f"Model saved to {model_path}")
