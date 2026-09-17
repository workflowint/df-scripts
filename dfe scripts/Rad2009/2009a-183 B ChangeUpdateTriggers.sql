DECLARE @FieldName VARCHAR(255)
DECLARE @TableName varchar(255)
DECLARE @TriggerName varchar(255)
DECLARE @TriggerID int
DECLARE @TriggerNumber int

DECLARE @TriggerText VARCHAR(8000)
DECLARE @TriggerTextOLD VARCHAR(8000)
DECLARE @SQLString VARCHAR(max)

SET QUOTED_IDENTIFIER ON
declare CurRow cursor GLOBAL for
select b.id,b.text,a.name,c.name,b.colid
 from sysobjects as A join syscomments as B on A.id=B.id
 join sysobjects as C on A.parent_obj=C.id
where A.xtype='TR' and OBJECTPROPERTY(A.id, 'ExecIsUpdateTrigger')=1
--and OBJECTPROPERTY(A.id, 'ExecIsDeleteTrigger')=1 
and text like '%getdate()%'  and a.name not in ('ActivityHistoryUpdate')
and b.id not in ( select id from syscomments where colid=2)
order by a.name
open CurRow
fetch next from CurRow into @TriggerID,@TriggerText,@TriggerName, @TableName,@TriggerNumber
 while (@@fetch_status = 0)
        begin
          SET QUOTED_IDENTIFIER ON
          set @TriggerTextOLD = @TriggerText
          if ( @TriggerName = 'CallSheetsUpdate')
			set @TriggerText = REPLACE(@TriggerText,'getdate()','getutcdate()')
          else
			set @TriggerText = REPLACE(@TriggerText,'getdate()','getutcdate(), UTCUpdatedOn=1 ')
          SET @SQLString  ='DROP TRIGGER  ['+@TriggerName+']'
          EXEC (@SQLString)
          SET @SQLString  =@TriggerText
		  BEGIN TRY
				EXEC (@SQLString)
		  END TRY
		  BEGIN CATCH
			SET @SQLString  =@TriggerTextOLD
			EXEC (@SQLString)
		  END CATCH
          SET QUOTED_IDENTIFIER OFF
          fetch next from CurRow into @TriggerID,@TriggerText,@TriggerName, @TableName,@TriggerNumber
      end
    close         CurRow
    deallocate CurRow

