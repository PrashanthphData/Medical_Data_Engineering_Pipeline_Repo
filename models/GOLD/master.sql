{{ config(
    database='GOLD',
    schema='MEDICAL_DATA'
) }}

SELECT 
    c.PATIENT_ID,
    dateofbirth,
    appointmentid,
    appointmentdatetime,
    appointmentdate,
    TEST_DATE,
    TEST_TYPE,
    TEST_RESULT,
    MEDICATIONTYPE,
    DOSAGE,
    STARTDATE,
    ENDDATE,
    
FROM
    {{source("csv_bronze_source","csv_preprocessing")}} c
JOIN 
    {{source("json_bronze_source","json_preprocessing")}} j
    ON c.patient_id = j.patientid
-- Uncomment the below if needed
JOIN 
   (SELECT s1.patientid,s1.appointmentid,
    s1.appointmentdatetime,
    s1.appointmentdate,s2.dateofbirth
    FROM {{source("sql_bronze_source","appointments_preprocessing")}} s1 
    JOIN {{source("sql_bronze_source","patients_preprocessing")}} s2 
    ON s1.patientid=s2.patientid) s 
   ON s.patientid=j.patientid
