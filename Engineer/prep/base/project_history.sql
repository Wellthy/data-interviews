SELECT history_id AS project_history_id
     , id AS project_id
     , type AS project_type
     , status AS project_status
     , LAG(status) OVER (PARTITION BY id ORDER BY history_id ASC) AS previous_project_status
     , first_active AS first_active_at
     , DATE(first_active) AS first_active_date
     , created AS created_at
     , DATE(created) AS created_date
     , history_date AS modified_at
     , DATE(history_date) AS modified_date
     , history_user_id AS modified_by
  FROM {{ source('wellthy', 'historical_project') }}