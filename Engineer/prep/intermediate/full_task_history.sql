SELECT history.task_id
     , history.task_title
     , tasks.task_type -- history table does not have task type field field
     , history.task_due_date
     , tasks.project_id -- history table does not have project ID field
     , history.task_status
     , history.previous_task_status
     , history.created_date
     , history.modified_date
     , MIN(history.modified_date) OVER (PARTITION BY history.task_id) AS first_modified_date
     , LEAD(history.modified_date) OVER (PARTITION BY history.task_id ORDER BY history.modified_date ASC) AS next_modified_date
     , LAG(history.modified_date) OVER (PARTITION BY history.task_id ORDER BY history.modified_date ASC) AS previous_modified_date
     , MIN(CASE WHEN history.task_status = 'IN_PROGRESS'
                 AND history.previous_task_status, '') != 'IN_PROGRESS'
                THEN history.modified_date
                ELSE NULL
            END) OVER (PARTITION BY history.task_id) AS first_in_progress_date
	 , MAX(CASE WHEN history.task_status = 'COMPLETE' 
	 			THEN history.modified_date
	 			ELSE NULL
	 		END) OVER (PARTITION BY history.task_id) AS last_completed_date
     , RANK() OVER (PARTITION BY history.task_id
                        ORDER BY history.task_history_id DESC) AS history_sequence
     , tasks.is_deleted_task
     , tasks.task_deleted_date
  FROM {{ ref('task_history') }} AS history
  JOIN {{ ref('tasks') }} AS tasks ON tasks.task_id = history.task_id