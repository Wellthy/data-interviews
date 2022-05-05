SELECT id AS task_id
     , created AS created_at
     , DATE(created) AS created_date
     , modified AS modified_at
     , DATE(modified) AS modified_date
     , status AS task_status
     , title AS task_title
     , CASE WHEN task_title = 'G' THEN 'General'
            WHEN task_title = 'I' THEN 'Internal'
            ELSE 'Task'
        END AS task_type
     , DATE(due) AS task_due_date
     , project_id
     , CASE WHEN _sdc_deleted_at IS NULL THEN FALSE
            ELSE TRUE
        END AS is_deleted_task
     , _sdc_deleted_at AS task_deleted_at
     , DATE(_sdc_deleted_at) AS task_deleted_date
  FROM {{ source('wellthy', 'task') }}