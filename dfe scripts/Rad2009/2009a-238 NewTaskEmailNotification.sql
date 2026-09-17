ALTER TABLE ClientConfig add SendNewTaskNotification bit, TaskNotificationSubject varchar(255),
TaskNotificationBody varchar(max)
select * from ClientConfig