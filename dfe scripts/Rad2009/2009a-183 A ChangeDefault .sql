ALTER TABLE SkillsCategories ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE SkillsCategories ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE MarketingCallReport ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE MarketingCallReport ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE MarketingCallReport ADD DEFAULT (suser_sname())  FOR CreatedBY
go
ALTER TABLE MarketingCallReport ADD DEFAULT (suser_sname()) FOR UpdatedBy
go
ALTER TABLE MarketingCallReport ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE MarketingCallReport ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE SkillsCategories ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE SkillsCategories ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE LinkUsersToStickies ADD UTCCreatedOn smallint DEFAULT (1) 
go
ALTER TABLE LinkUsersToStickies ADD UTCUpdatedOn smallint DEFAULT (1) 
go
ALTER TABLE IndustryCodes ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE IndustryCodes ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE IndustryCodes ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE IndustryCodes ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE SkillsAliases ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE SkillsAliases ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE SkillsAliases ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE SearchContactRecord ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE SearchContactRecord ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE SearchContactRecord ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE SearchContactRecord ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE PositionDetails ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE PositionDetails ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE PositionDetails ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE PositionDetails ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE Skills ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE Skills ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE Skills ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE Skills ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE ProjectsClientTeams ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE ProjectsClientTeams ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE ProjectsClientTeams ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE ProjectsClientTeams ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE ProjectsTeam ADD DEFAULT (getutcdate()) FOR CreatedOn
go
ALTER TABLE ProjectsTeam ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE ProjectsTeam ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE ProjectsTeam ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE ProjectsAccounting ADD DEFAULT (getutcdate()) FOR UpdatedOn
go
ALTER TABLE ProjectsAccounting ADD UTCCreatedOn smallint DEFAULT (1)
go
ALTER TABLE ProjectsAccounting ADD UTCUpdatedOn smallint DEFAULT (1)
go
ALTER TABLE ActivityHistory ADD IsUTCTime smallint DEFAULT (1)
go
ALTER TABLE ProjectsCallStatus ADD IsUTCTime smallint
go


DECLARE @FieldName VARCHAR(255)
DECLARE @TableName varchar(255)
DECLARE @ConstraintName varchar(255)

DECLARE @NewFieldName VARCHAR(255)

DECLARE @SQLString NVARCHAR(1000)

SET QUOTED_IDENTIFIER ON
 set @NewFieldName = 'UTCCreatedOn'
declare CurRow cursor GLOBAL for
select A.name as ColumnName,b.name as TableName,c.name as ConstrName
 from sys.columns as A join sys.objects as B on A.object_id=B.object_id
 join sys.objects as c on a.default_object_id=c.object_id
where b.type='u' and object_definition(default_object_id)='(getdate())'
order by 2 
open CurRow
fetch next from CurRow into @FieldName, @TableName,@ConstraintName
 while (@@fetch_status = 0)
        begin
          SET QUOTED_IDENTIFIER ON
          SET @SQLString  ='ALTER TABLE ['+@TableName+	  '] DROP CONSTRAINT  ['+@ConstraintName+']'
          EXEC (@SQLString)
          SET @SQLString  ='ALTER TABLE ['+@TableName+	  '] ADD CONSTRAINT  ['+@ConstraintName+'] DEFAULT (getutcdate()) FOR ['+@FieldName+']'
          EXEC (@SQLString)
          
          SET @SQLString  ='if not exists (select column_name from INFORMATION_SCHEMA.columns
               where table_name ='+CHAR(39)+ @TableName+CHAR(39)+' and column_name ='+CHAR(39)+ @NewFieldName+CHAR(39)+') '+
           ' begin '+    
           ' ALTER TABLE ['+@TableName+	  '] ADD UTCCreatedOn smallint DEFAULT (1)'+
           ' ALTER TABLE ['+@TableName+	  '] ADD UTCUpdatedOn smallint DEFAULT (1) end '           
           EXEC (@SQLString)
          SET QUOTED_IDENTIFIER OFF
          fetch next from CurRow into @FieldName, @TableName,@ConstraintName
      end
    close         CurRow
    deallocate CurRow

