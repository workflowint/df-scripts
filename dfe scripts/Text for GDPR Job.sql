
declare @PeopleID int
declare @AHID int
declare @Placed varchar(50)
declare @SL varchar(50)
declare @CLTeam varchar(50)
declare @Description varchar(255)

declare CurGDPR cursor LOCAL for
select PeopleID,
Placed=case when( select count(*) from Positions where Positions.PeopleID=People.PeopleID and (ProjectsID>0 or JobOrdersID > 0 )) >0
 then 'Placed' else '' end,
SL=case when( select count(*) from ProjectsShortLists where ProjectsShortLists.PeopleID=People.PeopleID  ) >0
 then 'on Short List for Project(s)' else '' end,
ClTeam=case when( select count(*) from ProjectsClientTeams where ProjectsClientTeams.PeopleID=People.PeopleID  ) >0
 then 'Client Team Member' else '' end
from People where ( PeopleID  in ( select PeopleID from Positions where PeopleID>0 and (ProjectsID>0 or JobOrdersID > 0))
or PeopleID  in ( select PeopleID from ProjectsShortLists )
or PeopleID  in ( select PeopleID from ProjectsClientTeams where PeopleID >0 ))
and IsNull(PermissiontoRetainData,0)=0 and PermissiontoRetainDate >'01/01/1920'
open CurGDPR
fetch next from CurGDPR into @PeopleID,@Placed,@SL,@CLTeam
while (@@fetch_status = 0)
        begin	
			exec GetNewID @Name='ActivityHistoryID',@LastID=@AHID output 
			set	@Description =@Placed
			if (datalength(@SL )>0)
			 begin
				set @Description =case when datalength(@Description)>0 then @Description+', '+@SL
									else @SL end
			 end
			if (datalength(@CLTeam )>0)
			 begin
				set @Description =case when datalength(@Description)>0 then @Description+', '+@CLTeam
									else @CLTeam end
			 end
			INSERT INTO ActivityHistory ( ActivityHistoryID, Type,Description,CompletedOn,IsUTCTime,Notes, ShortNotes )
			VALUES ( @AHID,'GDPR','Request to delete denied',GETUTCDATE(),1,@Description,@Description)
			INSERT INTO LinkObjectToActivityHistory ( RightID,LeftID,ObjectTableName)
			VALUES (@AHID,@PeopleID,'People')
			update People set PermissiontoRetainData=1 where PeopleID=@PeopleID        
          fetch next from CurGDPR into @PeopleID,@Placed,@SL,@CLTeam
    end 
          
close         CurGDPR
deallocate CurGDPR
delete from People where IsNull(PermissiontoRetainData,0)=0 and PermissiontoRetainDate >'01/01/1920'
