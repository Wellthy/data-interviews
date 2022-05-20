SELECT history.project_id
     , projects.creator_id -- history table does not have a project creator id field
     , history.project_type
     , history.project_status
     , history.previous_project_status
     , history.created_date
     , history.first_active_date
     , history.modified_date
     , MIN(CASE WHEN status.description = 'Paused'
                THEN history.modified_date
                ELSE NULL
            END) OVER (PARTITION BY history.project_id) AS first_paused_date
     , RANK() OVER (PARTITION BY history.project_id
                        ORDER BY history.project_history_id DESC) AS history_sequence
     , projects.project_deleted_date
  FROM {{ ref('project_history') }} AS history
  JOIN {{ ref('projects') }} AS projects ON projects.project_id = history.project_id