import pandas as pd
import random
from datetime import datetime, timedelta
import os

# Number of patients / visits
num_rows = 120

patients = [f"P{str(i).zfill(3)}" for i in range(1, 51)]
diseases = ["Common Cold", "Diabetes", "Stomach Pain", "Fever", "Fracture", "Heart Disease"]
doctor_types = ["General Physician", "Surgeon", "Cardiologist", "Diabetic"]
equipment = ["ECG", "X-Ray", "None", "Ultrasound", "MRI", "CT Scan", "Blood Test"]

data = []

start_date = datetime(2025, 1, 1)
for _ in range(num_rows):
    patient = random.choice(patients)
    visit_date = start_date + timedelta(days=random.randint(0, 364))
    visit_time = random.choice(["Morning", "Afternoon", "Evening"])
    visit_count = 1
    disease = random.choice(diseases)
    doctor_type = random.choice(doctor_types)
    equipment_used = random.choice(equipment)
    
    # Extra columns
    disease_category = "Chronic" if disease in ["Diabetes", "Heart Disease"] else "General"
    severity = random.choice(["Low", "Medium", "High"])
    referred = "Yes" if severity == "High" else "No"
    referred_to = "Specialist Hospital" if referred == "Yes" else "None"
    
    data.append([patient, visit_date.strftime("%Y-%m-%d"), visit_time, visit_count,
                 disease, disease_category, severity, doctor_type, equipment_used, referred, referred_to])

df = pd.DataFrame(data, columns=["patient_id", "visit_date", "visit_time", "visit_count",
                                 "disease", "disease_category", "severity",
                                 "doctor_type", "equipment_used", "referred", "referred_to"])

# Save CSV in data folder
csv_path = os.path.join(os.path.dirname(__file__), "../data/hospital_data.csv")
df.to_csv(csv_path, index=False)

print(f"✅ hospital_data.csv created with {num_rows} rows!")
