import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",                # replace with your user
    password="YOUR_PASSWORD",   # replace with your password
    database="hospital_db"
)

# Load data
df = pd.read_sql("SELECT * FROM hospital_visits", conn)
conn.close()

# Convert visit_date to datetime
df['visit_date'] = pd.to_datetime(df['visit_date'])

# Prepare analytics
monthly_patients = df.groupby(df['visit_date'].dt.to_period('M')).size()
doctor_counts = df['doctor_type'].value_counts()
equipment_counts = df['equipment_used'].value_counts()

# Create a figure with 3 subplots
fig, axes = plt.subplots(3, 1, figsize=(12, 15))
fig.tight_layout(pad=6)

# -----------------------
# 1. Monthly Patient Count
# -----------------------
axes[0].bar(monthly_patients.index.astype(str), monthly_patients.values, color='skyblue')
axes[0].set_title("Monthly Patient Count", fontsize=16)
axes[0].set_xlabel("Month")
axes[0].set_ylabel("Number of Patients")
axes[0].tick_params(axis='x', rotation=45)

# -----------------------
# 2. Doctor Type Distribution
# -----------------------
sns.barplot(x=doctor_counts.index, y=doctor_counts.values, ax=axes[1], palette="Set2")
axes[1].set_title("Doctor Type Distribution", fontsize=16)
axes[1].set_xlabel("Doctor Type")
axes[1].set_ylabel("Number of Visits")
axes[1].tick_params(axis='x', rotation=45)

# -----------------------
# 3. Equipment Usage
# -----------------------
sns.barplot(x=equipment_counts.index, y=equipment_counts.values, ax=axes[2], palette="Set1")
axes[2].set_title("Equipment Usage", fontsize=16)
axes[2].set_xlabel("Equipment")
axes[2].set_ylabel("Number of Uses")
axes[2].tick_params(axis='x', rotation=45)

# Show combined figure
plt.show()
