ALTER Table Responces add AfterBefore int
GO
if ( select count(*) from LinkSearchListsToCandStage where ListName='New Travel')=0
insert into LinkSearchListsToCandStage (SearchListID,ListName,IsList,ForJobOrders,ForPosition)
select max(SearchListID)+1, 'New Travel',0,1,1 from LinkSearchListsToCandStage
GO
IF EXISTS ( 
SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'fn_GetOwnersNameLine'
                    AND Routine_Type = 'FUNCTION' ) 
DROP FUNCTION [dbo].[fn_GetOwnersNameLine]
GO
CREATE FUNCTION  [dbo].[fn_GetOwnersNameLine] ( @PeopleID int, @Office varchar(6))
RETURNS varchar(255)
AS
BEGIN
DECLARE @Tmp varchar (255)
SELECT @Tmp = IsNull(COALESCE(@Tmp + ',', '') + UserList.Name,'') FROM LinkPeopleToOwner WITH(NOLOCK)
JOIN UserList WITH ( NOLOCK ) on LinkPeopleToOwner.Owner = UserList.LoginName
WHERE PeopleID =@PeopleID and LinkPeopleToOwner.Office =@Office
if (SubString(@Tmp,1,1)=  ',')
	set @Tmp=SubString(@Tmp,2,datalength(@Tmp))
RETURN @Tmp
END
GO
GRANT EXECUTE ON [dbo].[fn_GetOwnersNameLine] to [DeskFlowUsers]
