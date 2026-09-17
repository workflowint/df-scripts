CREATE TABLE [dbo].[LinkUsersToManager] (
	[UserID] [int] NOT NULL ,
	[ManagerID] [int] NOT NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LinkUsersToManager] WITH NOCHECK ADD 
	CONSTRAINT [PK_LinkUsersToManager] PRIMARY KEY  CLUSTERED 
	(
		[UserID],
		[ManagerID]
	)  ON [PRIMARY] 
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[LinkUsersToManager]  TO [DeskFlowUsers]
GO

ALTER TRIGGER [dbo].[UserListOnDelete] ON [dbo].[UserList] 
FOR  DELETE 
AS
declare @UserListID         int
declare @LoginName varchar(20)

declare Row cursor local  for
     select   UserListID, LoginName
     from 
         deleted
-----------------------------------------------------------------------------------------------------------
UPDATE DataCashTables set UpdatedOn = getdate()
WHERE Name ='UserList'

open Row

fetch next from Row into @UserListID, @LoginName

while @@fetch_status = 0
    begin

         delete from LinkUsersToWorkgroups            	where LeftID =  @UserListID
         delete from UserEMailSettings                        where LoginName =  @LoginName
         delete from Signatures                                    where LoginName =  @LoginName
         delete from LinkUserToMailBox            	where UserID =  @UserListID
         delete from LinkUserToMailBox            	where MailBoxID =  @UserListID
         delete from LinkUsersToManager            	where UserID =  @UserListID
         delete from LinkUsersToManager            	where ManagerID =  @UserListID
         delete from UserLastTouch                            where LoginName =@LoginName
         delete from UserNoArchiveEmails            where LoginName =@LoginName
         fetch next from Row into @UserListID, @LoginName

    end
          
close       Row
deallocate  Row

