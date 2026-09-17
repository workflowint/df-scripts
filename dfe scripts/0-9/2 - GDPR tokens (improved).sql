/****** Object:  Table [dbo].[GDPRLinks]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[GDPRLinks](
	[GDPRLinksID] [int] IDENTITY(1,1) NOT NULL,
	[PeopleID] [int] NULL,
	[Token] [varchar](255) NULL,
 CONSTRAINT [PK_GDPRLinks] PRIMARY KEY CLUSTERED 
(
	[GDPRLinksID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


create index ix_gdpr_token on gdprlinks(token)
go

create index ix_gdpr_peopleid on gdprlinks(peopleid) include(token)


go

SET ANSI_PADDING OFF
GO


GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[GDPRLinks]  TO [DeskFlowUsers]


GO

/****** Object:  StoredProcedure [dbo].[GetGDPRToken] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetGDPRToken] @peopleid int, @token varchar(255) OUTPUT

as

BEGIN

DECLARE @counter int
DECLARE @r varchar(12)
SET @counter = 0

SELECT @r = Token 
FROM GDPRLinks WITH(NOLOCK)
WHERE PeopleID = @peopleid

IF (@r IS NOT NULL)
BEGIN
	SET @token = @r
	RETURN
END

WHILE (@counter < 100)
BEGIN

	SELECT @r = coalesce(@r, '') + n
	FROM (SELECT top 12
	CHAR(number) n FROM
	master..spt_values
	WHERE type = 'P' AND 
	(number between ascii(0) and ascii(9)
	or number between ascii('A') and ascii('Z')
	or number between ascii('a') and ascii('z'))
	ORDER BY newid()) a

	IF NOT EXISTS( SELECT Token FROM GDPRLinks WITH(NOLOCK) WHERE Token = @r)
	BEGIN
		BREAK;
	END

	SET @counter = @counter + 1

END

IF( @r IS NOT NULL )
BEGIN

	INSERT INTO GDPRLinks (PeopleID, Token)
	VALUES (@peopleid, @r)
	
	SET @token = @r

END

END

GO

GRANT  EXECUTE  ON [dbo].[GetGDPRToken]  TO [DeskFlowUsers]

GO

/* Populate base tokens */
declare @PeopleID int
declare CurRowAn cursor local for
     select	PeopleID from people
open CurRowAn

fetch next from CurRowAn into @PeopleID

while @@fetch_status = 0
begin
    EXECUTE GetGDPRToken @PeopleID, NULL
	fetch next from CurRowAn into @PeopleID
end
          
close      CurRowAn
deallocate CurRowAn

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[PeopleGDPRToken] ON [dbo].[People] 
FOR INSERT
AS
declare @PeopleID int
declare CurRowAn cursor local for
     select  Inserted.PeopleID
from Inserted
open CurRowAn

fetch next from CurRowAn into @PeopleID

while @@fetch_status = 0
begin
    EXECUTE GetGDPRToken @PeopleID, NULL
	fetch next from CurRowAn into @PeopleID
end
          
close      CurRowAn
deallocate CurRowAn