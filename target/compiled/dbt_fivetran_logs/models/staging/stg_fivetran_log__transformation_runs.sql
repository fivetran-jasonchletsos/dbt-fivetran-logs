with source as (
    select * from JASON_CHLETSOS.JASON_CHLETSOS_FIVETRAN_LOG.transformation_runs
),

renamed as (
    select
        destination_id,
        job_id,
        measured_date,
        project_type,
        case 
            when free_type = 'free' then true
            else false
        end as is_free,
        job_name,
        updated_at,
        model_runs,
        _fivetran_synced
    from source
)

select * from renamed