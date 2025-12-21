import os
import io
import base64
from flask import Flask, render_template, request
import pandas as pd
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend for MacOS
import matplotlib.pyplot as plt
import seaborn as sns

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def process_csv(file_paths):
    """
    Process uploaded CSV files and return a base64 encoded dashboard image.
    """
    # Load CSVs and combine
    dfs = [pd.read_csv(fp) for fp in file_paths]
    data = pd.concat(dfs, ignore_index=True)

    # Ensure datetime
    data['visit_date'] = pd.to_datetime(data['visit_date'])
    data['month'] = data['visit_date'].dt.to_period('M')

    # Aggregate metrics
    monthly_visits = data.groupby('month')['visit_count'].sum()
    doctor_monthly = data.groupby(['month', 'doctor_type'])['visit_count'].sum().unstack(fill_value=0)
    equipment_monthly = data.groupby(['month', 'equipment_used'])['visit_count'].sum().unstack(fill_value=0)
    disease_monthly = data.groupby(['month', 'disease'])['visit_count'].sum().unstack(fill_value=0)

    # Create 2x2 grid for all charts
    fig, axes = plt.subplots(2, 2, figsize=(12, 8))
    plt.subplots_adjust(hspace=0.4, wspace=0.3)

    # ----- Monthly Patient Visits -----
    sns.barplot(x=monthly_visits.index.astype(str), y=monthly_visits.values,
                color='skyblue', ax=axes[0,0])
    axes[0,0].set_title("Monthly Patient Visits")
    axes[0,0].set_ylabel("Visits")
    axes[0,0].tick_params(axis='x', rotation=45)
    axes[0,0].grid(axis='y', linestyle='--', alpha=0.5)

    # ----- Doctor Visits per Month -----
    doctor_monthly.plot(kind='bar', stacked=True, ax=axes[0,1],
                        colormap='Set2', width=0.7)
    axes[0,1].set_title("Doctor Visits per Month")
    axes[0,1].set_ylabel("Visits")
    axes[0,1].tick_params(axis='x', rotation=45)
    axes[0,1].grid(axis='y', linestyle='--', alpha=0.5)
    axes[0,1].legend(title="Doctor Type", fontsize=8)

    # ----- Equipment Usage -----
    equipment_monthly.plot(kind='bar', stacked=True, ax=axes[1,0],
                           colormap='Set1', width=0.7)
    axes[1,0].set_title("Equipment Usage per Month")
    axes[1,0].set_ylabel("Usage Count")
    axes[1,0].set_xlabel("Month")
    axes[1,0].tick_params(axis='x', rotation=45)
    axes[1,0].grid(axis='y', linestyle='--', alpha=0.5)
    axes[1,0].legend(title="Equipment", fontsize=8)

    # ----- Disease Distribution -----
    disease_monthly.plot(kind='bar', stacked=True, ax=axes[1,1],
                         colormap='tab20', width=0.7)
    axes[1,1].set_title("Disease Distribution per Month")
    axes[1,1].set_ylabel("Patient Count")
    axes[1,1].set_xlabel("Month")
    axes[1,1].tick_params(axis='x', rotation=45)
    axes[1,1].grid(axis='y', linestyle='--', alpha=0.5)
    axes[1,1].legend(title="Disease", fontsize=8)

    # Convert figure to base64
    buf = io.BytesIO()
    fig.savefig(buf, format='png', bbox_inches='tight', dpi=150)
    buf.seek(0)
    img_base64 = base64.b64encode(buf.read()).decode('utf-8')
    plt.close(fig)
    return img_base64

@app.route('/', methods=['GET','POST'])
def index():
    dashboard_img = None
    if request.method == 'POST':
        uploaded_files = request.files.getlist("csv_files")
        file_paths = []
        for f in uploaded_files:
            path = os.path.join(app.config['UPLOAD_FOLDER'], f.filename)
            f.save(path)
            file_paths.append(path)
        if file_paths:
            dashboard_img = process_csv(file_paths)
    return render_template("dashboard.html", dashboard_img=dashboard_img)

if __name__ == "__main__":
    app.run(debug=True)
