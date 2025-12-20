import os
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend for MacOS
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from sqlalchemy import create_engine

# ------------------------------
# 1. Paths and directories
# ------------------------------
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # Project root
STATIC_DIR = os.path.join(BASE_DIR, "app", "static")
os.makedirs(STATIC_DIR, exist_ok=True)  # Ensure static folder exists
DASHBOARD_PATH = os.path.join(STATIC_DIR, "dashboard.png")

# ------------------------------
# 2. Connect to MySQL and load data
# ------------------------------
# Encode special characters in password if needed
engine = create_engine("mysql+mysqlconnector://root:Gixxerr%401408@localhost/hospital_db")

# Load table into pandas DataFrame
df = pd.read_sql("SELECT * FROM hospital_visits", engine)
print(f"Loaded {len(df)} rows from hospital_visits table.")

# ------------------------------
# 3. Prepare data for analysis
# ------------------------------
df['visit_date'] = pd.to_datetime(df['visit_date'])
df['month'] = df['visit_date'].dt.to_period('M')  # Monthly period
df['department'] = df['doctor_type']  # You can map doctor_type to department if needed

# Aggregate metrics
monthly_visits = df.groupby('month')['visit_count'].sum()
doctor_monthly = df.groupby(['month', 'doctor_type'])['visit_count'].sum().unstack(fill_value=0)
equipment_monthly = df.groupby(['month', 'equipment_used'])['visit_count'].sum().unstack(fill_value=0)
department_monthly = df.groupby(['month', 'department'])['visit_count'].sum().unstack(fill_value=0)

# ------------------------------
# 4. Plot Dashboard
# ------------------------------
fig, axes = plt.subplots(4, 1, figsize=(16, 18))
fig.suptitle("Hospital Analytics Dashboard", fontsize=22, y=0.95)

# ----- 4.1 Monthly Patient Visits -----
sns.barplot(
    x=monthly_visits.index.astype(str),
    y=monthly_visits.values,
    color="skyblue",
    ax=axes[0]
)
axes[0].set_title("Monthly Patient Visits", fontsize=16)
axes[0].set_ylabel("Number of Visits")
axes[0].set_xlabel("")
axes[0].tick_params(axis='x', rotation=0)
axes[0].grid(axis='y', linestyle='--', alpha=0.6)

# ----- 4.2 Doctor Visits per Month -----
doctor_monthly.plot(
    kind='bar',
    stacked=True,
    ax=axes[1],
    colormap='Set2',
    width=0.7
)
axes[1].set_title("Doctor Visits per Month", fontsize=16)
axes[1].set_ylabel("Number of Visits")
axes[1].set_xlabel("")
axes[1].tick_params(axis='x', rotation=0)
axes[1].grid(axis='y', linestyle='--', alpha=0.6)
axes[1].legend(title='Doctor Type', bbox_to_anchor=(1.02, 1), loc='upper left', fontsize=10)

# ----- 4.3 Equipment Usage per Month -----
equipment_monthly.plot(
    kind='bar',
    stacked=True,
    ax=axes[2],
    colormap='Set1',
    width=0.7
)
axes[2].set_title("Equipment Usage per Month", fontsize=16)
axes[2].set_ylabel("Usage Count")
axes[2].set_xlabel("Month")
axes[2].tick_params(axis='x', rotation=0)
axes[2].grid(axis='y', linestyle='--', alpha=0.6)
axes[2].legend(title='Equipment', bbox_to_anchor=(1.02, 1), loc='upper left', fontsize=10)

# ----- 4.4 Department Demand per Month -----
department_monthly.plot(
    kind='bar',
    stacked=True,
    ax=axes[3],
    colormap='tab20',
    width=0.7
)
axes[3].set_title("Department-wise Visits per Month", fontsize=16)
axes[3].set_ylabel("Number of Visits")
axes[3].set_xlabel("Month")
axes[3].tick_params(axis='x', rotation=0)
axes[3].grid(axis='y', linestyle='--', alpha=0.6)
axes[3].legend(title='Department', bbox_to_anchor=(1.02, 1), loc='upper left', fontsize=10)

# ----- 5. Layout and save -----
plt.tight_layout(rect=[0, 0, 0.83, 0.93], pad=4)
plt.savefig(DASHBOARD_PATH, dpi=300, bbox_inches='tight')
plt.close()

print(f"Dashboard saved successfully at {DASHBOARD_PATH}")
