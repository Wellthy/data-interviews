SELECT COALESCE(history.project_id, projects.project_id) AS project_id
     , projects.creator_id -- history table does not have a project creator id field
     , projects.name
     , COALESCE(history.project_type, projects.project_type) AS project_type
     , COALESCE(history.project_status, projects.project_status) AS project_status
     , history.previous_project_status
     , COALESCE(history.created_date, projects.created_date) AS created_date
     , COALESCE(history.first_active_date, projects.first_active_date) AS first_active_date
     , COALESCE(history.modified_date, projects.modified_date) AS modified_date
     , MIN(CASE WHEN status.description = 'Paused'
                THEN COALESCE(history.modified_date, projects.modified_date)
                ELSE NULL
            END) OVER (PARTITION BY projects.project_id) AS first_paused_date
     , RANK() OVER (PARTITION BY history.project_id
                        ORDER BY history.project_history_id DESC) AS history_sequence
	 , max(case when status.description = 'Complete' 
	 			then coalesce(history.modified_date, projects.modified_date) --modified_date
	 			else null
	 		end) over (partition by history.project_id) as last_completed_date
     , projects.project_deleted_date
  FROM {{ ref('projects') }} AS projects
  LEFT JOIN {{ ref('project_history') }} AS history ON history.project_id = projects.project_id