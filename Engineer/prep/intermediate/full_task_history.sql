SELECT tasks.task_id
     , COALESCE(history.task_title, tasks.task_title) AS task_title
     , tasks.task_type
     , COALESCE(history.task_due_date, tasks.task_due_date) AS task_due_date
     , tasks.project_id
     , COALESCE(history.task_status, tasks.task_status) AS task_status
     , previous_status.description AS previous_task_status
     , COALESCE(history.created_date, tasks.created_date) AS created_date
     , COALESCE(history.modified_date, tasks.modified_date) AS modified_date
     , MIN(COALESCE(history.modified_date, tasks.modified_date)) OVER (PARTITION BY tasks.task_id) AS first_modified_date
     , LEAD(COALESCE(history.modified_date, tasks.modified_date)) OVER (PARTITION BY tasks.task_id ORDER BY COALESCE(history.modified_date, tasks.modified_date) ASC) AS next_modified_date
     , LAG(COALESCE(history.modified_date, tasks.modified_date)) OVER (PARTITION BY tasks.task_id ORDER BY COALESCE(history.modified_date, tasks.modified_date) ASC) AS previous_modified_date
     , MIN(CASE WHEN status.description = 'IN_PROGRESS'
                 AND COALESCE(previous_status.description, '') != 'IN_PROGRESS'
                THEN COALESCE(history.modified_date, tasks.modified_date) --modified_date
                ELSE NULL
            END) OVER (PARTITION BY history.task_id) AS first_in_progress_date
     , MIN(CASE WHEN status.description = 'IN_PROGRESS'
                 AND history.adviser_id IS NOT NULL
                THEN COALESCE(history.modified_date, tasks.modified_date) --modified_date
                ELSE NULL
            END) OVER (PARTITION BY history.task_id) AS first_assigned_to_adviser_date
	 , MAX(CASE WHEN status.description = 'COMPLETE' 
	 			THEN COALESCE(history.modified_date, tasks.modified_date) --modified_date
	 			ELSE NULL
	 		END) OVER (PARTITION BY history.task_id) AS last_completed_date
     , RANK() OVER (PARTITION BY history.task_id
                        ORDER BY history.task_history_id DESC) AS history_sequence
     , tasks.is_deleted_task
     , tasks.task_deleted_date
  FROM {{ ref('tasks') }} AS tasks
  LEFT JOIN {{ ref('task_history') }} AS history ON history.task_id = tasks.task_id