import pandas as pd
import mysql.connector
import os

# CSV path
csv_path = os.path.join(os.path.dirname(__file__), "../data/hospital_data.csv")

# Load CSV into DataFrame
df = pd.read_csv(csv_path)

# Replace NaN with None (MySQL understands NULL)
df = df.where(pd.notnull(df), None)

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",               
    password="Gixxerr@1408",   
    database="hospital_db"
)
cursor = conn.cursor()

# Insert query
insert_query = """
INSERT INTO hospital_visits
(patient_id, visit_date, visit_time, visit_count, disease, doctor_type, equipment_used)
VALUES (%s, %s, %s, %s, %s, %s, %s)
"""

# Clear table before inserting to avoid duplicates
cursor.execute("DELETE FROM hospital_visits")

# Insert each row
for _, row in df.iterrows():
    cursor.execute(insert_query, tuple(row))

conn.commit()
cursor.close()
conn.close()

print(f"{len(df)} rows inserted successfully into hospital_visits!")
