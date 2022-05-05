SELECT id AS project_id
     , type AS project_type
     , status AS project_status
     , first_active AS first_active_at
     , DATE(first_active) AS first_active_date
     , created AS created_at
     , DATE(created) AS created_date
     , modified AS modified_at
     , DATE(modified) AS modified_date
     , creator_id
     , CASE WHEN _sdc_deleted_at IS NULL THEN FALSE
            ELSE TRUE
        END AS is_deleted_project
     , _sdc_deleted_at AS project_deleted_at
     , DATE(_sdc_deleted_at) AS project_deleted_date
  FROM {{ source('wellthy', 'project') }}