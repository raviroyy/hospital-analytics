import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# ----------------------
# 1. Define parameters
# ----------------------
months = pd.date_range(start="2025-01-01", end="2025-12-31", freq='D')
diseases = ["Common Cold", "Diabetes", "Stomach Pain", "Flu", "Fracture"]
doctor_types = ["General Physician", "Surgeon", "Pediatrician", "Diabetic Specialist"]
equipment_list = ["X-ray", "MRI", "Ultrasound", "ECG", "None"]

# ----------------------
# 2. Generate random data
# ----------------------
data = []
patient_id = 1

for date in months:
    num_patients_today = random.randint(5, 15)  # random patients per day
    for _ in range(num_patients_today):
        visit_count = random.randint(1, 2)  # visits per patient
        disease = random.choice(diseases)
        doctor_type = random.choice(doctor_types)
        equipment_used = random.choice(equipment_list)
        data.append([
            f"P{patient_id:04d}",
            date.strftime("%Y-%m-%d"),
            f"{random.randint(8, 17)}:{random.choice(['00','30'])}",  # visit time
            visit_count,
            disease,
            doctor_type,
            equipment_used
        ])
        patient_id += 1

# ----------------------
# 3. Create DataFrame
# ----------------------
df = pd.DataFrame(data, columns=[
    "patient_id",
    "visit_date",
    "visit_time",
    "visit_count",
    "disease",
    "doctor_type",
    "equipment_used"
])

# ----------------------
# 4. Save CSV
# ----------------------
df.to_csv("hospital_data_2025.csv", index=False)
print("hospital_data_2025.csv created with 1 year random data!")
