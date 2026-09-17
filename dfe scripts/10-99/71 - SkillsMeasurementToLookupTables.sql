if ( select COUNT(*) from LookupTables where Name='SkillsMeasurement')=0
insert into LookupTables(Name,Description,Editable,Visible,CanDelete)
values ( 'SkillsMeasurement','Skills Measurement','Name','Name',1)
