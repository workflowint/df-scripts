ALTER TABLE EMailArchive add MsgBodyHTMLW ntext, MsgBodyTextW ntext
go
declare @type1 int
declare @type2 int
set @type1 = (select b.xtype from sysobjects as a join syscolumns as b on a.id=b.id
where a.name='EMailArchive' and b.name ='MsgBodyText')
set @type2 = (select b.xtype from sysobjects as a join syscolumns as b on a.id=b.id
where a.name='EMailArchive' and b.name ='MsgBodyHTML')
if ( @type1 = 35 or @type2=35)
begin
select EMailArchiveID,MsgBodyHTML,MsgBodyText into EMailArchiveText_bak from EMailArchive
update EMailArchive set MsgBodyTextW = MsgBodyText, MsgBodyHTMLW=MsgBodyHTML
ALTER TABLE EMailArchive drop column MsgBodyHTML
ALTER TABLE EMailArchive drop column MsgBodyText
exec sp_rename 'EMailArchive.MsgBodyHTMLW', 'MsgBodyHTML', 'COLUMN'
exec sp_rename 'EMailArchive.MsgBodyTextW', 'MsgBodyText', 'COLUMN'
end


