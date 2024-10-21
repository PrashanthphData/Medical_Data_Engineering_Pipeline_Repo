{{ config(
    database='BRONZE',
    schema='MEDICAL_DATA_CSV',
    
) }}

WITH RankedDuplicates AS (
    SELECT 
        patient_id,
        test_type,
        test_date,
        test_result,
        ROW_NUMBER() OVER (PARTITION BY patient_id, test_type, test_date, test_result ORDER BY (SELECT NULL)) AS rnk
    FROM 
        {{ source("raw_csv", "MEDICALDATA") }}
)

SELECT 
    patient_id,
    test_type,
    test_date,
    test_result
FROM 
    RankedDuplicates
WHERE 
    rnk = 1  -- Keep only the first occurrence
