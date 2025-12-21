import os
import io
import base64
from flask import Flask, render_template, request
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns

from analytics.prediction_engine import (
    can_predict,
    predict_patient_volume,
    predict_doctor_demand,
    predict_equipment_usage,
    disease_probability
)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# -----------------------------
# CSV Processing & Dashboard
# -----------------------------
def process_csv(file_paths):
    # Load and merge all CSV files
    dfs = [pd.read_csv(fp) for fp in file_paths]
    data = pd.concat(dfs, ignore_index=True)

    # Ensure datetime and month
    data['visit_date'] = pd.to_datetime(data['visit_date'])
    data['month'] = data['visit_date'].dt.to_period('M')

    # Aggregate metrics
    monthly_visits = data.groupby('month')['visit_count'].sum()
    doctor_monthly = data.groupby(['month', 'doctor_type'])['visit_count'].sum().unstack(fill_value=0)
    equipment_monthly = data.groupby(['month', 'equipment_used'])['visit_count'].sum().unstack(fill_value=0)
    disease_monthly = data.groupby(['month', 'disease'])['visit_count'].sum().unstack(fill_value=0)

    # Helper function: convert plot to base64
    def plot_to_base64(fig):
        buf = io.BytesIO()
        fig.savefig(buf, format='png', bbox_inches='tight', dpi=150)
        buf.seek(0)
        img_base64 = base64.b64encode(buf.read()).decode('utf-8')
        plt.close(fig)
        return img_base64

    # -----------------------------
    # Create 2x2 dashboard figure
    # -----------------------------
    fig, axes = plt.subplots(2, 2, figsize=(12, 8))
    plt.subplots_adjust(hspace=0.35, wspace=0.3)

    # Top-left: Monthly Patient Visits
    sns.barplot(x=monthly_visits.index.astype(str), y=monthly_visits.values, color='skyblue', ax=axes[0,0])
    axes[0,0].set_title("Monthly Patient Visits")
    axes[0,0].set_ylabel("Visits")
    axes[0,0].set_xlabel("")
    axes[0,0].tick_params(axis='x', rotation=45)
    axes[0,0].grid(axis='y', linestyle='--', alpha=0.5)

    # Top-right: Doctor Visits per Month
    if not doctor_monthly.empty:
        doctor_monthly.plot(kind='bar', stacked=True, ax=axes[0,1], colormap='Set2', width=0.7)
        axes[0,1].set_title("Doctor Visits per Month")
        axes[0,1].set_ylabel("Visits")
        axes[0,1].set_xlabel("")
        axes[0,1].tick_params(axis='x', rotation=45)
        axes[0,1].grid(axis='y', linestyle='--', alpha=0.5)

    # Bottom-left: Equipment Usage
    if not equipment_monthly.empty:
        equipment_monthly.plot(kind='bar', stacked=True, ax=axes[1,0], colormap='Set1', width=0.7)
        axes[1,0].set_title("Equipment Usage per Month")
        axes[1,0].set_ylabel("Usage Count")
        axes[1,0].set_xlabel("Month")
        axes[1,0].tick_params(axis='x', rotation=45)
        axes[1,0].grid(axis='y', linestyle='--', alpha=0.5)

    # Bottom-right: Disease Distribution
    if not disease_monthly.empty:
        disease_monthly.plot(kind='bar', stacked=True, ax=axes[1,1], colormap='tab20', width=0.7)
        axes[1,1].set_title("Disease Distribution per Month")
        axes[1,1].set_ylabel("Patient Count")
        axes[1,1].set_xlabel("Month")
        axes[1,1].tick_params(axis='x', rotation=45)
        axes[1,1].grid(axis='y', linestyle='--', alpha=0.5)

    return plot_to_base64(fig), data

# -----------------------------
# Flask Routes
# -----------------------------
@app.route('/', methods=['GET','POST'])
def index():
    dashboard_img = None
    predictions = {}
    if request.method == 'POST':
        uploaded_files = request.files.getlist("csv_files")
        file_paths = []
        for f in uploaded_files:
            path = os.path.join(app.config['UPLOAD_FOLDER'], f.filename)
            f.save(path)
            file_paths.append(path)

        dashboard_img, df = process_csv(file_paths)

        # Check if predictions are possible
        if can_predict(df):
            # Generate predictions safely
            patient_forecast = predict_patient_volume(df)
            doctor_forecast = predict_doctor_demand(df)
            equipment_forecast = predict_equipment_usage(df)
            disease_forecast = disease_probability(df)
            
            predictions = {
                "patient_forecast": patient_forecast.to_dict(orient='records') if not patient_forecast.empty else None,
                "doctor_forecast": {k: v.to_dict(orient='records') for k, v in doctor_forecast.items() if not v.empty},
                "equipment_forecast": {k: v.to_dict(orient='records') for k, v in equipment_forecast.items() if not v.empty},
                "disease_forecast": {k: v.to_dict(orient='records') for k, v in disease_forecast.items() if not v.empty}
            }

    return render_template("dashboard.html", dashboard_img=dashboard_img, predictions=predictions)

# -----------------------------
if __name__ == "__main__":
    app.run(debug=True)
