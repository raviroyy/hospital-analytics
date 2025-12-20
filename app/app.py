import os
import io
from flask import Flask, render_template, request
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import seaborn as sns
import base64

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def process_csv(file_paths):
    # Load all CSVs
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

    def plot_to_base64(fig):
        buf = io.BytesIO()
        fig.savefig(buf, format='png', bbox_inches='tight', dpi=150)
        buf.seek(0)
        img_base64 = base64.b64encode(buf.read()).decode('utf-8')
        plt.close(fig)
        return img_base64

    # Create 2x2 grid
    fig, axes = plt.subplots(2, 2, figsize=(12, 8))
    plt.subplots_adjust(hspace=0.4, wspace=0.3)
    
    # Top-left: Monthly Patient Visits
    sns.barplot(x=monthly_visits.index.astype(str), y=monthly_visits.values, color='skyblue', ax=axes[0,0])
    axes[0,0].set_title("Monthly Patient Visits")
    axes[0,0].set_ylabel("Visits")
    axes[0,0].set_xlabel("")
    axes[0,0].tick_params(axis='x', rotation=45)
    axes[0,0].grid(axis='y', linestyle='--', alpha=0.5)

    # Top-right: Doctor Visits per Month
    doctor_monthly.plot(kind='bar', stacked=True, ax=axes[0,1], colormap='Set2', width=0.7)
    axes[0,1].set_title("Doctor Visits per Month")
    axes[0,1].set_ylabel("Visits")
    axes[0,1].set_xlabel("")
    axes[0,1].tick_params(axis='x', rotation=45)
    axes[0,1].grid(axis='y', linestyle='--', alpha=0.5)

    # Bottom-left: Equipment Usage
    equipment_monthly.plot(kind='bar', stacked=True, ax=axes[1,0], colormap='Set1', width=0.7)
    axes[1,0].set_title("Equipment Usage per Month")
    axes[1,0].set_ylabel("Usage Count")
    axes[1,0].set_xlabel("Month")
    axes[1,0].tick_params(axis='x', rotation=45)
    axes[1,0].grid(axis='y', linestyle='--', alpha=0.5)

    # Bottom-right: Disease Distribution
    disease_monthly.plot(kind='bar', stacked=True, ax=axes[1,1], colormap='tab20', width=0.7)
    axes[1,1].set_title("Disease Distribution per Month")
    axes[1,1].set_ylabel("Patient Count")
    axes[1,1].set_xlabel("Month")
    axes[1,1].tick_params(axis='x', rotation=45)
    axes[1,1].grid(axis='y', linestyle='--', alpha=0.5)

    return plot_to_base64(fig)

@app.route('/', methods=['GET','POST'])
def index():
    if request.method == 'POST':
        uploaded_files = request.files.getlist("csv_files")
        file_paths = []
        for f in uploaded_files:
            path = os.path.join(app.config['UPLOAD_FOLDER'], f.filename)
            f.save(path)
            file_paths.append(path)
        dashboard_img = process_csv(file_paths)
        return render_template("dashboard.html", dashboard_img=dashboard_img)
    return render_template("dashboard.html")

if __name__ == "__main__":
    app.run(debug=True)
