{{ config(
    database='BRONZE',
    schema='APPOINTMENTS_PATIENTS_DATA_SQL_SERVER',) }}

with BRONZE_PATIENTS as (
    select PATIENTID,NAME,POSTALCODE,DATEOFBIRTH
    from {{source("raw_sql_server","PATIENTS")}}
    order by PATIENTID
)

select *
from BRONZE_PATIENTS