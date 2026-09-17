
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER TRIGGER [dbo].[PeopleUpdateWebLogin] ON [dbo].[People]
FOR UPDATE 
AS
BEGIN

UPDATE WebLogins
SET  
	LoginName = Inserted.WebLoginName
FROM Inserted JOIN Deleted ON
( Inserted.PeopleID = Deleted.PeopleID
	AND ( Inserted.WebLoginName <> Deleted.WebLoginName ) 
)
WHERE WebLogins.LoginName = Deleted.WebLoginName
	AND NOT EXISTS (
		SELECT LoginName 
		FROM WebLogins WITH(NOLOCK) 
		WHERE LoginName = Inserted.WebLoginName
	) 

END
