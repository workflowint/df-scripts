ALTER TABLE IntInterviewResults add PrePopulate bit default 0
go
UPDATE  IntInterviewResults set PrePopulate = 0 where PrePopulate is null
