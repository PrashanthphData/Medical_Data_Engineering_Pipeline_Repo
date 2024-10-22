{{ config(
    database='GOLD',
    schema='MEDICAL_DATA'
) }}
SELECT
    c.PATIENT_ID,
    name,
    postalcode AS postal_code,
    dateofbirth AS DOB,
    appointmentid AS appointment_id,
    appointmentdatetime AS appointment_datetime,
    appointmentdate AS appointment_date,
    TEST_DATE,
    TEST_TYPE,
    TEST_RESULT,
    MEDICATIONTYPE AS MEDICATION_TYPE,
    DOSAGE AS MEDICATION_DOSAGE,
    STARTDATE AS MEDICATION_STARTDATE,
    ENDDATE AS MEDICATION_ENDDATE,
FROM
    {{source("csv_bronze_source","csv_preprocessing")}} c
JOIN
    {{source("json_bronze_source","json_preprocessing")}} j
    ON c.patient_id = j.patientid
-- Uncomment the below if needed
JOIN
   (SELECT s1.patientid,s1.appointmentid,
    s1.appointmentdatetime,
    s1.appointmentdate,s2.dateofbirth,s2.name,s2.postalcode
    FROM {{source("sql_bronze_source","appointments_preprocessing")}} s1
    JOIN {{source("sql_bronze_source","patients_preprocessing")}} s2
    ON s1.patientid=s2.patientid) s
   ON s.patientid=j.patientid