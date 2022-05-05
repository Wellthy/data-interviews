SELECT full_project_history.project_id
     , full_project_history.creator_id
     , full_project_history.project_type
     , full_project_history.project_status
     , full_project_history.previous_project_status
     , full_project_history.created_date
     , full_project_history.first_active_date
     , full_project_history.first_paused_date
     , COUNT(full_task_history.task_id) AS number_of_tasks
  FROM {{ ref('full_project_history') }} AS full_project_history
  JOIN {{ ref('full_task_history') }} AS full_task_history ON full_task_history.project_id = full_project_history.project_id
 WHERE full_project_history.history_sequence = 1
   AND full_task_history.history_sequence = 1
 GROUP BY full_project_history.project_id
        , full_project_history.creator_id
        , full_project_history.project_type
        , full_project_history.project_status
        , full_project_history.previous_project_status
        , full_project_history.created_date
        , full_project_history.first_active_date
        , full_project_history.first_paused_date