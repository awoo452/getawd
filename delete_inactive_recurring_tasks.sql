UPDATE tasks SET recurring_task_id = NULL WHERE recurring_task_id IN (1, 4, 9, 11, 17, 18, 23, 25);
DELETE FROM recurring_tasks WHERE id IN (1, 4, 9, 11, 17, 18, 23, 25);
