ALTER TABLE UserLastTouch add DefaultTaskType int, DefaultShowTimeAs int, DefaultDuration int
go
update UserLastTouch set DefaultTaskType = 1,  DefaultShowTimeAs=2, DefaultDuration = 30 where DefaultTaskType is null
