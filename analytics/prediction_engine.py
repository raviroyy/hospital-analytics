import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression

def can_predict(df):
    df['visit_date'] = pd.to_datetime(df['visit_date'])
    return df['visit_date'].dt.year.nunique() >= 3

def _forecast(df):
    df = df.copy()
    df['month'] = pd.to_datetime(df['visit_date']).dt.to_period('M').astype(str)
    monthly = df.groupby('month')['visit_count'].sum().reset_index()
    monthly['t'] = np.arange(len(monthly))

    X = monthly[['t']]
    y = monthly['visit_count']

    model = LinearRegression().fit(X, y)

    future_t = np.arange(len(monthly), len(monthly)+12).reshape(-1, 1)
    preds = model.predict(future_t).astype(int)

    return pd.DataFrame({
        'month': pd.date_range(monthly['month'].iloc[-1], periods=12, freq='M'),
        'visit_count_forecast': preds
    })

def predict_patient_volume(df):
    return _forecast(df)

def predict_doctor_demand(df):
    return {d: _forecast(df[df['doctor_type'] == d]) for d in df['doctor_type'].dropna().unique()}

def predict_equipment_usage(df):
    return {e: _forecast(df[df['equipment_used'] == e]) for e in df['equipment_used'].dropna().unique()}

def disease_probability(df):
    return {d: _forecast(df[df['disease'] == d]) for d in df['disease'].dropna().unique()}
