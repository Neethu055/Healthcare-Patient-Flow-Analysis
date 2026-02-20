Create database healthcare;
use healthcare;
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SET SESSION sql_mode='';
SHOW VARIABLES LIKE "secure_file_priv";

CREATE TABLE healthcare_patient_flow (
    patient_id VARCHAR(20),
    admission_date DATE,
    admission_time TIME,
    doctor_name VARCHAR(100),
    patient_gender VARCHAR(20),
    patient_age INT,
    patient_race VARCHAR(50),
    department_referral VARCHAR(100),
    admission_flag VARCHAR(20),
    patient_satisfaction_score DECIMAL(3,1),
    patient_wait_time INT,
    admission_flag_num INT,
    age_group VARCHAR(20),
    wait_time_bucket VARCHAR(50),
    admission_datetime FLOAT
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/healthcare_analytics_patient_flow_data.csv"
INTO TABLE healthcare_patient_flow
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    patient_id,
    admission_date,
    admission_time,
    doctor_name,
    patient_gender,
    patient_age,
    patient_race,
    department_referral,
    admission_flag,
    patient_satisfaction_score,
    patient_wait_time,
    admission_flag_num,
    age_group,
    wait_time_bucket,
    admission_datetime
);

SET SQL_SAFE_UPDATES = 0;


UPDATE healthcare_patient_flow
SET admission_date = STR_TO_DATE(admission_date,'%d-%m-%Y');

SELECT TIME_FORMAT(admission_time,'%h:%i %p')
FROM healthcare_patient_flow;

SET SQL_SAFE_UPDATES = 1;

#1. Total Number of Patients
SELECT COUNT(*) AS total_patients
FROM healthcare_patient_flow;

#2.Admission vs Not Admitted Patients
SELECT admission_flag, COUNT(*) AS total_patients
FROM healthcare_patient_flow
GROUP BY admission_flag;

#3.Admission Percentage
SELECT 
    admission_flag,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM healthcare_patient_flow) AS percentage
FROM healthcare_patient_flow
GROUP BY admission_flag;

#4.Average Patient Age
SELECT AVG(patient_age) AS average_age
FROM healthcare_patient_flow;

#5.Patient Distribution by Age Group
SELECT age_group, COUNT(*) AS total_patients
FROM healthcare_patient_flow
GROUP BY age_group
ORDER BY total_patients DESC;

#6.Patient Count by Gender
SELECT patient_gender, COUNT(*) AS total_patients
FROM healthcare_patient_flow
GROUP BY patient_gender;

#7.Average Waiting Time
SELECT AVG(patient_wait_time) AS avg_wait_time
FROM healthcare_patient_flow;

#8.Waiting Time by Department
SELECT department_referral, 
       AVG(patient_wait_time) AS avg_wait_time
FROM healthcare_patient_flow
GROUP BY department_referral
ORDER BY avg_wait_time DESC;

#9.Patient Satisfaction Score Overall
SELECT AVG(patient_satisfaction_score) AS avg_satisfaction
FROM healthcare_patient_flow;

#10.Satisfaction Score by Department
SELECT department_referral,
       AVG(patient_satisfaction_score) AS avg_satisfaction
FROM healthcare_patient_flow
GROUP BY department_referral
ORDER BY avg_satisfaction DESC;

#11.Daily Patient Visits Trend
SELECT admission_date,
       COUNT(*) AS patient_count
FROM healthcare_patient_flow
GROUP BY admission_date
ORDER BY admission_date;

#12.Peak Admission Hours
SELECT HOUR(admission_time) AS hour,
       COUNT(*) AS patient_count
FROM healthcare_patient_flow
GROUP BY hour
ORDER BY patient_count DESC;

#13.Doctor Workload Analysis
SELECT doctor_name,
       COUNT(*) AS patient_count
FROM healthcare_patient_flow
GROUP BY doctor_name
ORDER BY patient_count DESC;

#14.Admission Rate by Department
SELECT department_referral,
       SUM(admission_flag_num) AS admitted_patients,
       COUNT(*) AS total_patients
FROM healthcare_patient_flow
GROUP BY department_referral;

#15.Waiting Time Bucket Distribution
SELECT wait_time_bucket,
       COUNT(*) AS patient_count
FROM healthcare_patient_flow
GROUP BY wait_time_bucket
ORDER BY patient_count DESC;

#16.Relationship Between Waiting Time & Satisfaction
SELECT wait_time_bucket,
       AVG(patient_satisfaction_score) AS avg_satisfaction
FROM healthcare_patient_flow
GROUP BY wait_time_bucket
ORDER BY avg_satisfaction;

#17.Monthly Patient Trend
SELECT 
    MONTH(admission_date) AS month,
    COUNT(*) AS patient_count
FROM healthcare_patient_flow
GROUP BY month
ORDER BY month;

#18.Race Distribution
SELECT patient_race,
       COUNT(*) AS patient_count
FROM healthcare_patient_flow
GROUP BY patient_race
ORDER BY patient_count DESC;





