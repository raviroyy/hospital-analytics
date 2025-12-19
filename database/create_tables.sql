CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

CREATE TABLE IF NOT EXISTS hospital_visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(10),
    visit_date DATE,
    visit_time VARCHAR(20),
    visit_count INT DEFAULT 1,
    disease VARCHAR(100),
    doctor_type VARCHAR(100),
    equipment_used VARCHAR(100)

);
