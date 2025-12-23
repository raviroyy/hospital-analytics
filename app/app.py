import os
import io
import base64
from flask import Flask, render_template, request
import pandas as pd

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns
import calendar


from analytics.prediction_engine import (
    can_predict,
    predict_patient_volume,
    predict_doctor_demand,
    predict_equipment_usage,
    disease_probability
)

# -----------------------------
# Flask App Config
# -----------------------------
app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER



# -----------------------------
# CSV Processing & Dashboard
# -----------------------------
def process_csv(file_paths):
    dfs = [pd.read_csv(fp) for fp in file_paths]
    data = pd.concat(dfs, ignore_index=True)

    # Ensure required columns
    data["visit_date"] = pd.to_datetime(data["visit_date"])
    data["month"] = data["visit_date"].dt.to_period("M").dt.to_timestamp()

    # Aggregations
    monthly_visits = data.groupby("month")["visit_count"].sum()
    monthly_only = (
        monthly_visits
        .groupby(monthly_visits.index.month)
        .sum()
    )

    doctor_monthly = (
        data.groupby(["month", "doctor_type"])["visit_count"]
        .sum()
        .unstack(fill_value=0)
    )

    equipment_monthly = (
        data.groupby(["month", "equipment_used"])["visit_count"]
        .sum()
        .unstack(fill_value=0)
    )

    disease_monthly = (
        data.groupby(["month", "disease"])["visit_count"]
        .sum()
        .unstack(fill_value=0)
    )

    # Helper: figure to base64
    def fig_to_base64(fig):
        buf = io.BytesIO()
        fig.savefig(buf, format="png", bbox_inches="tight", dpi=140)
        buf.seek(0)
        img = base64.b64encode(buf.read()).decode("utf-8")
        plt.close(fig)
        return img

    # -----------------------------
    # Dashboard Figure (2x2)
    # -----------------------------
    fig, axes = plt.subplots(2, 2, figsize=(30, 15))
    plt.subplots_adjust(hspace=0.35, wspace=0.25)

    # 1️⃣ Monthly Patient Visits

    sns.barplot(
        x=monthly_visits.index,
        y=monthly_visits.values,
        ax=axes[0, 0],
        color="#4C72B0"
    )

    axes[0, 0].set_title("Monthly Patient Visits")
    axes[0, 0].grid(axis="y", linestyle="--", alpha=0.5)

    # 🔧 Month + Year labels
    axes[0, 0].set_xticklabels(
        monthly_visits.index.strftime('%b-%Y'),
        rotation=90
    )

    # 2️⃣ Doctor Demand
    if not doctor_monthly.empty:
        doctor_monthly.plot(
            kind="bar",
            stacked=True,
            ax=axes[0, 1],
            colormap="Set2",
            width=0.8
        )
        axes[0, 1].set_title("Doctor Demand by Month")
        axes[0, 1].tick_params(rotation=90)
        axes[0, 1].grid(axis="y", linestyle="--", alpha=0.5)
        axes[0, 1].set_xticklabels(
            doctor_monthly.index.strftime('%b-%Y'),
            rotation=90
        )
        

    # 3️⃣ Equipment Usage
    if not equipment_monthly.empty:
        equipment_monthly.plot(
            kind="bar",
            stacked=True,
            ax=axes[1, 0],
            colormap="Set1",
            width=0.8
        )
        axes[1, 0].set_title("Equipment Usage by Month")
        axes[1, 0].tick_params(axis="x", rotation=45)
        axes[1, 0].grid(axis="y", linestyle="--", alpha=0.5)
        axes[1, 0].set_xticklabels(
            equipment_monthly.index.strftime('%b-%Y'),
            rotation=90
        )

    # 4️⃣ Disease Trends
    if not disease_monthly.empty:
        disease_monthly.plot(
            kind="bar",
            stacked=True,
            ax=axes[1, 1],
            colormap="tab20",
            width=0.8
        )
        axes[1, 1].set_title("Disease Distribution by Month")
        axes[1, 1].tick_params(axis="x", rotation=45)
        axes[1, 1].grid(axis="y", linestyle="--", alpha=0.5)
        axes[1, 1].set_xticklabels(
            disease_monthly.index.strftime('%b-%Y'),
            rotation=90
        )

    dashboard_img = fig_to_base64(fig)
    return dashboard_img, data

# -----------------------------
# Routes
# -----------------------------
@app.route("/", methods=["GET", "POST"])
def index():
    dashboard_img = None
    predictions = {}
    can_run_prediction = False

    if request.method == "POST":
        uploaded_files = request.files.getlist("csv_files")
        file_paths = []

        for f in uploaded_files:
            save_path = os.path.join(app.config["UPLOAD_FOLDER"], f.filename)
            f.save(save_path)
            file_paths.append(save_path)

        dashboard_img, df = process_csv(file_paths)

        # Prediction only if >= 3 years
        can_run_prediction = can_predict(df)

        if can_run_prediction:
            predictions = {
                "patient_forecast": predict_patient_volume(df).to_dict(orient="records"),

                "doctor_forecast": {
                    k: v.to_dict(orient="records")
                    for k, v in predict_doctor_demand(df).items()
                },

                "equipment_forecast": {
                    k: v.to_dict(orient="records")
                    for k, v in predict_equipment_usage(df).items()
                },

                "disease_forecast": {
                    k: v.to_dict(orient="records")
                    for k, v in disease_probability(df).items()
                }
            }

    return render_template(
        "dashboard.html",
        dashboard_img=dashboard_img,
        predictions=predictions,
        can_predict=can_run_prediction
    )


# -----------------------------
if __name__ == "__main__":
    app.run(debug=True)
