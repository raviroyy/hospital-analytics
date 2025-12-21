import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression

# -----------------------------
# 1. Check if predictions can be made
# -----------------------------
def can_predict(df):
    """
    Returns True if data spans 3 or more years, else False
    """
    if 'visit_date' not in df.columns:
        return False
    df['visit_date'] = pd.to_datetime(df['visit_date'], errors='coerce')
    df = df.dropna(subset=['visit_date'])
    years = df['visit_date'].dt.year.nunique()
    return years >= 3

# -----------------------------
# 2. Helper: Linear regression forecasting
# -----------------------------
def forecast_monthly(df, column_name):
    """
    Forecast next 12 months using linear regression
    df: DataFrame with 'month' and target column
    column_name: str, target to forecast
    Returns: DataFrame with next 12 months forecast
    """
    df = df.copy()
    if 'month' not in df.columns:
        df['month'] = pd.to_datetime(df['visit_date']).dt.to_period('M')
    df['month'] = pd.to_datetime(df['month'].astype(str), errors='coerce')
    df = df.dropna(subset=['month', column_name])

    # Aggregate monthly
    monthly = df.groupby(pd.Grouper(key='month', freq='M'))[column_name].sum().reset_index()
    monthly = monthly.sort_values('month')
    monthly['month_num'] = np.arange(len(monthly))

    if len(monthly) < 3:  # Not enough data to forecast
        return pd.DataFrame(columns=['month', f'{column_name}_forecast'])

    X = monthly[['month_num']]
    y = monthly[column_name]

    model = LinearRegression()
    model.fit(X, y)

    # Forecast next 12 months
    future_months_num = np.arange(len(monthly), len(monthly)+12).reshape(-1, 1)
    y_pred = model.predict(future_months_num)

    future_index = pd.date_range(
        monthly['month'].iloc[-1] + pd.offsets.MonthBegin(1),
        periods=12,
        freq='M'
    )

    forecast_df = pd.DataFrame({
        'month': future_index,
        f'{column_name}_forecast': y_pred.round().astype(int)
    })
    return forecast_df

# -----------------------------
# 3. Predict patient volume
# -----------------------------
def predict_patient_volume(df):
    return forecast_monthly(df, 'visit_count')

# -----------------------------
# 4. Predict doctor demand
# -----------------------------
def predict_doctor_demand(df):
    doctor_forecast = {}
    if 'doctor_type' not in df.columns:
        return doctor_forecast

    for doctor in df['doctor_type'].dropna().unique():
        sub_df = df[df['doctor_type'] == doctor]
        doctor_forecast[doctor] = forecast_monthly(sub_df, 'visit_count')
    return doctor_forecast

# -----------------------------
# 5. Predict equipment usage
# -----------------------------
def predict_equipment_usage(df):
    equipment_forecast = {}
    if 'equipment_used' not in df.columns:
        return equipment_forecast

    for eq in df['equipment_used'].dropna().unique():
        sub_df = df[df['equipment_used'] == eq]
        equipment_forecast[eq] = forecast_monthly(sub_df, 'visit_count')
    return equipment_forecast

# -----------------------------
# 6. Predict disease probability
# -----------------------------
def disease_probability(df):
    disease_forecast = {}
    if 'disease' not in df.columns:
        return disease_forecast

    for disease in df['disease'].dropna().unique():
        sub_df = df[df['disease'] == disease]
        disease_forecast[disease] = forecast_monthly(sub_df, 'visit_count')
    return disease_forecast
