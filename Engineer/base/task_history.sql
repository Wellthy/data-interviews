SELECT history_id AS task_history_id
     , id AS task_id
     , created AS created_at
     , DATE(created) AS created_date
     , status AS task_status
     , LAG(status) OVER (PARTITION BY id ORDER BY history_id ASC) AS previous_task_status
     , DATE(due) AS task_due_date
     , history_date AS modified_at
     , DATE(history_date) AS modified_date
     , history_user_id AS modified_by
     , title AS task_title
  FROM {{ source('wellthy', 'historical_task') }}
-- If the _sdc_deleted_at column exists, we want to exclude it
{%- if if_column_exists('source', 'historical_task', '_sdc_deleted_at') %}
 WHERE _sdc_deleted_at IS NULL
{%- endif -%}