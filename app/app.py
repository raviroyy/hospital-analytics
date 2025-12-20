import matplotlib
matplotlib.use('Agg')  # Must be BEFORE importing pyplot
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from flask import Flask, request, render_template
import os
import io
import base64

app = Flask(__name__)
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), "../data")
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Home route
@app.route("/", methods=["GET", "POST"])
def index():
    chart_img = None
    message = ""
    
    if request.method == "POST":
        if 'file' not in request.files:
            message = "No file part"
            return render_template("dashboard.html", chart_img=chart_img, message=message)
        
        file = request.files['file']
        if file.filename == "":
            message = "No selected file"
            return render_template("dashboard.html", chart_img=chart_img, message=message)
        
        if file:
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
            file.save(filepath)
            
            # Read CSV
            df = pd.read_csv(filepath)
            
            # Simple analytics
            df['visit_date'] = pd.to_datetime(df['visit_date'])
            monthly_patients = df.groupby(df['visit_date'].dt.to_period('M')).size()
            
            # Plot chart
            plt.figure(figsize=(10,5))
            sns.barplot(x=monthly_patients.index.astype(str), y=monthly_patients.values, color='skyblue')
            plt.xticks(rotation=45)
            plt.title("Monthly Patient Count")
            
            # Save chart to PNG in memory
            buf = io.BytesIO()
            plt.tight_layout()
            plt.savefig(buf, format="png")
            buf.seek(0)
            chart_img = base64.b64encode(buf.getvalue()).decode()
            buf.close()
            
            message = f"CSV loaded successfully ({len(df)} rows)"
    
    return render_template("dashboard.html", chart_img=chart_img, message=message)

if __name__ == "__main__":
    app.run(debug=True)
