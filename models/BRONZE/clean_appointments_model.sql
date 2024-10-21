{{ config(materialized='view') }}

with BRONZE_APPOINTMENTS as (
    select APPOINTMENTID, APPOINTMENTDATE, APPOINTMENTTIME, PATIENTID
    from {{source("raw_sql_server","APPOINTMENTS")}}
    order by APPOINTMENTID
)

select *
from BRONZE_APPOINTMENTS