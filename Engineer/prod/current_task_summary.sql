select distinct
    full_task_history.task_id,
    full_task_history.task_title,
    full_task_history.task_type,
    full_task_history.task_due_date,
    full_task_history.project_id,
    full_task_history.task_status,
    full_task_history.first_in_progress_date,
    full_task_history.first_assigned_to_adviser_date,
    full_task_history.last_completed_date
from {{ ref('full_task_history') }} full_task_history
where full_task_history.history_sequence = 1