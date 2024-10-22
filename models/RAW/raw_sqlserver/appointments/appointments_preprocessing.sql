{{ config(
    database='BRONZE',
    schema='APPOINTMENTS_PATIENTS_DATA_SQL_SERVER',) }}

with BRONZE_APPOINTMENTS as (
    select 
        APPOINTMENTID, 
        APPOINTMENTDATE, 
        TO_TIMESTAMP_NTZ(CONCAT(APPOINTMENTDATE, ' ', APPOINTMENTTIME), 'YYYY-MM-DD HH24:MI:SS.FF7') AS APPOINTMENTDATETIME,  -- Adjusted format for fractional seconds
        PATIENTID
    from {{source("raw_sql_server","APPOINTMENTS")}}
    order by APPOINTMENTID
)

select *
from BRONZE_APPOINTMENTS
