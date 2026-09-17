ALTER TABLE ClientConfig add GDPRSupport bit
GO
update ClientConfig set GDPRSupport = 0 where GDPRSupport is null
GO
ALTER TABLE UserList ALTER COLUMN PermitLevel varchar(3)
GO
ALTER TABLE People add PermissiontoRetainData bit, PermissiontoRetainDate datetime
GO
CREATE FUNCTION  [dbo].[fn_GetAllEmails] ( @PeopleID int )
RETURNS varchar(max)
AS
BEGIN
DECLARE @Tmp varchar (max)
SELECT @Tmp =CASE WHEN @Tmp is null then '' else @Tmp+',' END + char(39)+ Address+char(39) FROM EMailAddress
where PeopleID = @PeopleID order by UpdatedOn desc
RETURN @Tmp
END
GO

GRANT  EXECUTE ON [dbo].[fn_GetAllEmails]  TO [DeskFlowUsers]

GO
