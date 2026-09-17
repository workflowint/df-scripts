ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_UTCCreatedOn]  DEFAULT ((1)) FOR [UTCCreatedOn]
GO

ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_UTCUpdatedOn]  DEFAULT ((1)) FOR [UTCUpdatedOn]

