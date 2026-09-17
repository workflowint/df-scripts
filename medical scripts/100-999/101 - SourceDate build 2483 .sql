ALTER TABLE LinkPeopleToSources add SourceDate datetime
GO
ALTER TABLE [dbo].[TravelInfo] ADD  CONSTRAINT [DF_TravelInfo_UpdateOn1]  DEFAULT (getutcdate()) FOR [UpdatedOn]
GO
ALTER TABLE [dbo].[TravelInfo] ADD  CONSTRAINT [DF_TravelInfo_UpdatedBy1]  DEFAULT (suser_sname()) FOR [UpdatedBy]
GO
update LinkPeopleToSources set SourceDate = CreatedOn where SourceDate is null
GO
if ( select count(*) from ExcelMapping where FieldName= 'MEDSourceDate')=0
insert into ExcelMapping( FieldName, TableName, FieldLabel, FieldSize,FieldType,IsDefault,ImportType)
Values ('MEDSourceDate','CandidateSources','Source Date',0,'DateTime',1,0)


