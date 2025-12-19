import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Gixxerr@1408",  
    database="hospital_db"
)

# Load data into DataFrame
df = pd.read_sql("SELECT * FROM hospital_visits", conn)
conn.close()

# Convert visit_date to datetime
df['visit_date'] = pd.to_datetime(df['visit_date'])

# ---------------------------
# Monthly Patient Count
# ---------------------------
monthly_patients = df.groupby(df['visit_date'].dt.to_period('M')).size()
print("Monthly patient count:")
print(monthly_patients)

# Plot monthly patient count
plt.figure(figsize=(10,5))
monthly_patients.plot(kind='bar', color='skyblue')
plt.title("Monthly Patient Count")
plt.xlabel("Month")
plt.ylabel("Number of Patients")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# ---------------------------
# Most Visited Doctor Type
# ---------------------------
doctor_counts = df['doctor_type'].value_counts()
print("\nMost visited doctor type:")
print(doctor_counts)

# Plot doctor type distribution
plt.figure(figsize=(8,4))
sns.barplot(x=doctor_counts.index, y=doctor_counts.values, palette="Set2")
plt.title("Doctor Type Distribution")
plt.xlabel("Doctor Type")
plt.ylabel("Number of Visits")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# ---------------------------
# Equipment Usage
# ---------------------------
equipment_counts = df['equipment_used'].value_counts()
print("\nEquipment usage:")
print(equipment_counts)

# Plot equipment usage
plt.figure(figsize=(8,4))
sns.barplot(x=equipment_counts.index, y=equipment_counts.values, palette="Set1")
plt.title("Equipment Usage")
plt.xlabel("Equipment")
plt.ylabel("Number of Uses")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
