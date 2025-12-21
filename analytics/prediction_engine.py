# analytics/prediction_engine.py

import pandas as pd
import numpy as np

# --------------------------------------------------
# Utility: check if prediction is allowed
# --------------------------------------------------
def can_predict(df: pd.DataFrame) -> bool:
    """
    Allow prediction only if data spans >= 3 years
    """
    df['visit_date'] = pd.to_datetime(df['visit_date'])
    years = df['visit_date'].dt.year.nunique()
    return years >= 3


# --------------------------------------------------
# Patient volume prediction (simple trend model)
# --------------------------------------------------
def predict_patient_volume(df: pd.DataFrame):
    df['visit_date'] = pd.to_datetime(df['visit_date'])
    df['month'] = df['visit_date'].dt.to_period('M')

    monthly = df.groupby('month')['visit_count'].sum()
    trend = monthly.rolling(3).mean()

    return trend.tail(12)  # next year (placeholder)


# --------------------------------------------------
# Doctor demand prediction
# --------------------------------------------------
def predict_doctor_demand(df: pd.DataFrame):
    df['visit_date'] = pd.to_datetime(df['visit_date'])
    df['month'] = df['visit_date'].dt.to_period('M')

    doctor_monthly = (
        df.groupby(['month', 'doctor_type'])['visit_count']
        .sum()
        .groupby(level=1)
        .mean()
        .sort_values(ascending=False)
    )

    return doctor_monthly


# --------------------------------------------------
# Equipment usage prediction
# --------------------------------------------------
def predict_equipment_usage(df: pd.DataFrame):
    equipment_usage = (
        df.groupby('equipment_used')['visit_count']
        .sum()
        .sort_values()
    )
    return equipment_usage


# --------------------------------------------------
# Disease probability by month
# --------------------------------------------------
def disease_probability(df: pd.DataFrame):
    df['visit_date'] = pd.to_datetime(df['visit_date'])
    df['month'] = df['visit_date'].dt.month

    disease_dist = (
        df.groupby(['month', 'disease'])['visit_count']
        .sum()
        .groupby(level=0)
        .apply(lambda x: x / x.sum())
    )

    return disease_dist
