ALTER TABLE ClientConfig add ShowMultPositionForPeople bit
GO
update ClientConfig  set ShowMultPositionForPeople =0
GO
if (select count(*) from ProgramComponents where name='Web Job Postings View')=0
BEGIN
INSERT INTO Programcomponents (Name) VALUES ('Web Job Postings View')
update workgroups set ProgramComponents =ProgramComponents+','+LTRIM(RTRIM(STR((select ProgramComponentsID from ProgramComponents
where name='Web Job Postings View')))) where ProgramComponents like '%,%'
END
ALTER TABLE WebApplications add Owner1 varchar(20)
GO
ALTER TABLE Duplicates add Owner1 varchar(20)
