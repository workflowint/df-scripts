SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DocuSignDocuments](
	[DocID] [int] IDENTITY(1,1) NOT NULL,
	[DocuSignID] [int] NULL,
	[OriginalDocumentID] [int] NULL,
	[SignedDocumentID] [int] NULL,
	[CertificateDocumentID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DocID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DocuSignDocuments]  WITH CHECK ADD FOREIGN KEY([DocuSignID])
REFERENCES [dbo].[DocuSign] ([DocuSignID])
GO
GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[DocuSignDocuments] TO [DeskFlowUsers]

GO
ALTER TRIGGER [dbo].[DocuSignUpdate] ON [dbo].[DocuSign]
FOR UPDATE 
AS
BEGIN
declare @OldStatus nvarchar(255)
declare @NewStatus nvarchar(255)
declare @DocuSignID int
declare @DocID int
declare @Type nvarchar(20)
declare @DocName nvarchar(1000)
declare @PersonName nvarchar(255)
declare @AHID int
declare @Msg nvarchar(max)
declare @Description nvarchar(1000)
declare @EnvelopeID nvarchar(255)
SELECT  @OldStatus = Upper(IsNull(deleted.EnvelopeStatus,'')), 
		@NewStatus = Upper(IsNull(inserted.EnvelopeStatus,'')),
		@DocuSignID = inserted.DocuSignID,
		@EnvelopeID = IsNull(inserted.EnvelopeID,'')
		FROM inserted JOIN deleted ON ( inserted.DocuSignID = deleted.DocuSignID )
		
if(@OldStatus <> @NewStatus and @NewStatus in ('SENT', 'ERROR', 'COMPLETE'))
	BEGIN
		set @Type = 'DocuSign Sent'
		SELECT @Description =CASE WHEN @Description is null then '' else @Description+', ' END + 
		IsNull(FirstName,'')+' '+IsNull(LastName,'') FROM 
		DocuSignSignees with ( nolock)join people with ( nolock)
		on 	DocuSignSignees.PeopleID = people.peopleid
		where DocuSignID=@DocuSignID

		SELECT @DocName =CASE WHEN @DocName is null then '' else @DocName+', ' END + 
		Document.Name FROM 
		DocuSignDocuments with ( nolock) join Document with ( nolock)
		on 	DocuSignDocuments.OriginalDocumentID = Document.Documentid
		where DocuSignID=@DocuSignID

		set @Description = 'Sent '+@DocName+' to '+@Description
		if (  @NewStatus = 'ERROR')
			begin
				set @Type = 'DocuSign Error'
				UPDATE Document set DocuSignStatus=3 where DocumentID in 
				( select OriginalDocumentID from DocuSignDocuments where DocuSignID=@DocuSignID)
			end
		if (  @NewStatus = 'COMPLETE')
			set @Type = 'DocuSign Complete'
		EXECUTE dbo.GetNewID 'ActivityHistoryID', @AHID output

		SET @Msg = 'EnvelopeID= ' + @EnvelopeID
		INSERT INTO ActivityHistory( ActivityHistoryID, Type, Description, Completedby,CompletedOn,IsUTCTime,Notes,ShortNotes )
		VALUES ( @AHID, @Type, SubString(@Description, 1, 255), suser_sname(),getdate(),1, @Msg,SubString(@Msg,1,255)) 
		INSERT INTO LinkObjectToActivityHistory( RightID, LeftId,ObjectTableName )
		SELECT  distinct @AHID,LeftID,ObjectTableName FROM LinkObjectToDocument where RightID in 
				( select OriginalDocumentID from DocuSignDocuments where DocuSignID=@DocuSignID)
		INSERT INTO LinkObjectToActivityHistory( RightID, LeftId,ObjectTableName )
		SELECT   @AHID,OriginalDocumentID,'Document' from DocuSignDocuments where DocuSignID=@DocuSignID
    END
END

