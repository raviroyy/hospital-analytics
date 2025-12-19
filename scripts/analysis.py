import mysql.connector
import pandas as pd

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

# Monthly patient count
monthly_patients = df.groupby(df['visit_date'].dt.to_period('M')).size()
print("Monthly patient count:")
print(monthly_patients)

# Most visited doctor type
print("\nMost visited doctor type:")
print(df['doctor_type'].value_counts())

# Equipment usage
print("\nEquipment usage:")
print(df['equipment_used'].value_counts())
