CREATE OR REPLACE VIEW GOLD.MEDICAL_DATA.MASTER AS (

    SELECT 
        p.PATIENTID AS PATIENT_ID,
        p.NAME,
        p.DATEOFBIRTH,
        p.POSTALCODE,
        a.APPOINTMENTID,
        a.APPOINTMENTTIME,
        a.APPOINTMENTDATE,
        m.TEST_DATE,
        m.TEST_TYPE,
        m.TEST_RESULT,
        md._DATA:"MedicationType"::STRING AS MEDICATIONTYPE,
        md._DATA:"Dosage"::STRING AS DOSAGE,
        md._DATA:"StartDate"::DATE AS MEDICATIONSTARTDATE,
        md._DATA:"EndDate"::DATE AS MEDICATIONENDDATE
        
    FROM
        {{source("sql_bronze_source", "patients_preprocessing")}} p
    
    LEFT JOIN 
        {{source("sql_bronze_source", "appointments_preprocessing")}} a
        ON p.PATIENTID = a.PATIENTID
        AND a._FIVETRAN_DELETED = FALSE
    
    -- Join medical test data from CSV, ensuring that only valid test data is included
    LEFT JOIN 
        {{source("csv_bronze_source", "csv_preprocessing")}} m
        ON p.PATIENTID = m.PATIENT_ID
        AND m.TEST_DATE IS NOT NULL
        AND m.TEST_RESULT IS NOT NULL
    
    -- Join medication data from JSON, ensuring that only valid medication data is included
    LEFT JOIN 
        {{source("json_bronze_source", "json_preprocessing")}} md
        ON p.PATIENTID = md._DATA:"PatientID"::NUMBER
        AND md._DATA:"MedicationType" IS NOT NULL
        AND md._DATA:"StartDate" IS NOT NULL
        AND md._DATA:"EndDate" IS NOT NULL

    WHERE
        p._FIVETRAN_DELETED = FALSE
        AND p.PATIENTID IS NOT NULL
        AND p.NAME IS NOT NULL
);