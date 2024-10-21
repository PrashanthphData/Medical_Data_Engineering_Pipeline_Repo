{{ config(
    database='BRONZE',
    schema='MEDICATIONS_DATA_JSON'
) }}

WITH preprocessed_medication_data AS (
    SELECT
        _DATA:Dosage::string AS Dosage,
        _DATA:StartDate::date AS StartDate,
        _DATA:EndDate::date AS EndDate,
        _DATA:MedicationType::string AS MedicationType,
        _DATA:PatientID::int AS PatientID
    FROM {{ source('raw_json', 'MEDICATIONSDATA') }}
)

-- Create a view with the flattened data and remove duplicates
SELECT DISTINCT *
FROM preprocessed_medication_data
