ALTER TABLE ScheduleStatus add DefaultValue bit 
GO
if ( select COUNT(*) from ScheduleStatus where DefaultValue=1 and ScheduleStatus='Free')=0
insert into ScheduleStatus ( ScheduleStatus,FontColor,DefaultValue)
values ('Free', 8388608,1)
if ( select COUNT(*) from ScheduleStatus where DefaultValue=1 and ScheduleStatus='Open')=0
insert into ScheduleStatus ( ScheduleStatus,FontColor,DefaultValue)
values ('Open', 65280,1)
if ( select COUNT(*) from ScheduleStatus where PlacedDefault=1)=0
insert into ScheduleStatus ( ScheduleStatus,FontColor,PlacedDefault)
values ('Filled', 255,1)
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Provinces]') AND name = N'PK_Provinces')
ALTER TABLE [dbo].[Provinces] DROP CONSTRAINT [PK_Provinces]
GO
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Provinces]') AND name = N'ProvinceCode')
DROP INDEX [ProvinceCode] ON [dbo].[Provinces] WITH ( ONLINE = OFF )
GO
ALTER TABLE Provinces alter column provinceCode varchar(5) NOT NULL
GO
CREATE NONCLUSTERED INDEX [ProvinceCode] ON [dbo].[Provinces] 
(
	[ProvinceCode] ASC
)
GO
ALTER TABLE [dbo].[Provinces] ADD  CONSTRAINT [PK_Provinces] PRIMARY KEY CLUSTERED 
(
	[ProvinceID] ASC
)