import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# ------------------------------
# 1. Connect to MySQL
# ------------------------------
conn = mysql.connector.connect(
    host="localhost",
    user="root",                
    password="Gixxerr@1408",   
    database="hospital_db"
)

# Load data
df = pd.read_sql("SELECT * FROM hospital_visits", conn)
conn.close()

# Convert visit_date to datetime
df['visit_date'] = pd.to_datetime(df['visit_date'])
df['month'] = df['visit_date'].dt.to_period('M')

# ------------------------------
# 2. Prepare Aggregated Analytics
# ------------------------------
monthly_visits = df.groupby('month')['visit_count'].sum()
doctor_monthly = df.groupby(['month', 'doctor_type'])['visit_count'].sum().unstack(fill_value=0)
equipment_monthly = df.groupby(['month', 'equipment_used'])['visit_count'].sum().unstack(fill_value=0)

# ------------------------------
# 3. Create Horizontal-Text Dashboard
# ------------------------------
fig, axes = plt.subplots(3, 1, figsize=(16, 14))  # compact, readable
fig.suptitle("Hospital Analytics Dashboard", fontsize=20, y=0.95)

# -----------------------
# Section 1: Monthly Patient Visits
# -----------------------
sns.barplot(x=monthly_visits.index.astype(str), y=monthly_visits.values, palette="Blues_d", ax=axes[0])
axes[0].set_title("Monthly Patient Visits", fontsize=16)
axes[0].set_ylabel("Visits", fontsize=12)
axes[0].set_xlabel("")
axes[0].tick_params(axis='x', rotation=0, labelsize=10)  # horizontal
axes[0].grid(axis='y', linestyle='--', alpha=0.6)

# -----------------------
# Section 2: Doctor Visits per Month
# -----------------------
doctor_monthly.plot(kind='bar', stacked=True, ax=axes[1], colormap='Set2', width=0.7)
axes[1].set_title("Doctor Visits per Month", fontsize=16)
axes[1].set_ylabel("Visits", fontsize=12)
axes[1].set_xlabel("")
axes[1].tick_params(axis='x', rotation=0, labelsize=10)  # horizontal
axes[1].grid(axis='y', linestyle='--', alpha=0.6)
axes[1].legend(title='Doctor Type', bbox_to_anchor=(1.02, 1), loc='upper left', fontsize=10)

# -----------------------
# Section 3: Equipment Usage per Month
# -----------------------
equipment_monthly.plot(kind='bar', stacked=True, ax=axes[2], colormap='Set1', width=0.7)
axes[2].set_title("Equipment Usage per Month", fontsize=16)
axes[2].set_ylabel("Usage", fontsize=12)
axes[2].set_xlabel("Month", fontsize=12)
axes[2].tick_params(axis='x', rotation=0, labelsize=10)  # horizontal
axes[2].grid(axis='y', linestyle='--', alpha=0.6)
axes[2].legend(title='Equipment', bbox_to_anchor=(1.02, 1), loc='upper left', fontsize=10)

# -----------------------
# Layout adjustments
# -----------------------
plt.tight_layout(rect=[0, 0, 0.83, 0.93], pad=4)  # reserve space for legends

# Show dashboard
plt.show()
