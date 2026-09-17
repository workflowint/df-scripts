ALTER TABLE Document alter column Name varchar(255)
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocuSign](
	[DocuSignID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[OriginalDocumentID] [int] NULL,
	[SignedDocumentID] [int] NULL,
	[CertificateDocumentID] [int] NULL,
	[EnvelopeID] [varchar](255) NULL,
	[EnvelopeStatus] [varchar](255) NULL,
	[SentOn] [datetime] NULL,
	[EmailSubject] [varchar](255) NULL,
	[EmailBody] [text] NULL
PRIMARY KEY CLUSTERED 
(
	[DocuSignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocuSign] ADD  DEFAULT (getutcdate()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[DocuSign] ADD  DEFAULT (suser_sname()) FOR [CreatedBy]
GO

ALTER TABLE [dbo].[DocuSign]  WITH CHECK ADD FOREIGN KEY([CertificateDocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO

ALTER TABLE [dbo].[DocuSign]  WITH CHECK ADD FOREIGN KEY([OriginalDocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO

ALTER TABLE [dbo].[DocuSign]  WITH CHECK ADD FOREIGN KEY([SignedDocumentID])
REFERENCES [dbo].[Document] ([DocumentID])
GO

GO

CREATE TRIGGER [dbo].[DocuSignUpdate] ON [dbo].[DocuSign]
FOR UPDATE 
AS
BEGIN
declare @OldStatus varchar(255)
declare @NewStatus varchar(255)
declare @DocuSignID int
declare @DocID int
declare @Type varchar(20)
declare @DocName varchar(255)
declare @PersonName varchar(255)
declare @AHID int
declare @Msg varchar(max)
declare @Description varchar(1000)
declare @EnvelopeID varchar(255)
SELECT  @OldStatus = Upper(IsNull(deleted.EnvelopeStatus,'')), 
		@NewStatus = Upper(IsNull(inserted.EnvelopeStatus,'')),
		@DocuSignID = inserted.DocuSignID,
		@DocID = inserted.OriginalDocumentID,
		@EnvelopeID = IsNull(inserted.EnvelopeID,''),
		@DocName = Document.Name
		FROM inserted JOIN deleted ON ( inserted.DocuSignID = deleted.DocuSignID )
		join document with (nolock) on inserted.OriginalDocumentID=document.documentid
		
if(@OldStatus <> @NewStatus and @NewStatus in ('SENT', 'ERROR', 'COMPLETE'))
	BEGIN
		set @Type = 'DocuSign Sent'
		--set @Description = ''
		SELECT @Description =CASE WHEN @Description is null then '' else @Description+', ' END + 
		IsNull(FirstName,'')+' '+IsNull(LastName,'') FROM 
		DocuSignSignees with ( nolock)join people with ( nolock)
		on 	DocuSignSignees.PeopleID = people.peopleid
		where DocuSignID=@DocuSignID
		set @Description = 'Sent '+@DocName+' to '+@Description
		if (  @NewStatus = 'ERROR')
			begin
				set @Type = 'DocuSign Error'
				UPDATE Document set DocuSignStatus=3 where DocumentID=@DocID	
			end
		if (  @NewStatus = 'COMPLETE')
			set @Type = 'DocuSign Complete'
		EXECUTE dbo.GetNewID 'ActivityHistoryID', @AHID output

		SET @Msg = 'EnvelopeID= ' + @EnvelopeID
		INSERT INTO ActivityHistory( ActivityHistoryID, Type, Description, Completedby,CompletedOn,IsUTCTime,Notes,ShortNotes )
		VALUES ( @AHID, @Type, @Description, suser_sname(),getdate(),1, @Msg,SubString(@Msg,1,255)) 
		INSERT INTO LinkObjectToActivityHistory( RightID, LeftId,ObjectTableName )
		SELECT  @AHID,LeftID,ObjectTableName FROM LinkObjectToDocument where RightID=@DocID
		INSERT INTO LinkObjectToActivityHistory( RightID, LeftId,ObjectTableName )
		VALUES  ( @AHID,@DocID,'Document' )
    END
END

GO

ALTER TABLE [dbo].[DocuSign] ENABLE TRIGGER [DocuSignUpdate]
GO

CREATE TABLE [dbo].[DocuSignSignees](
	[SigneeID] [int] IDENTITY(1,1) NOT NULL,
	[DocuSignID] [int] NULL,
	[Type] [varchar](1) NULL,
	[PeopleID] [int] NULL,
	[LoginName] [varchar](255) NULL,
	[Role] [varchar](255) NULL,
	[Email] [varchar](100) NULL,
	[CCOnly] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[SigneeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocuSignSignees]  WITH CHECK ADD FOREIGN KEY([DocuSignID])
REFERENCES [dbo].[DocuSign] ([DocuSignID])
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DocuSign] TO [DeskFlowUsers]
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DocuSignSignees] TO [DeskFlowUsers]