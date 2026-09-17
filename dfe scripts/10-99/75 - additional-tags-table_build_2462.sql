if object_id('TemplateAdditionalTags', 'U') is not null
	drop table TemplateAdditionalTags
go

create table TemplateAdditionalTags
(
	TemplateAdditionalTagsID int identity primary key
	,
	TemplatesID int not null
	,
	DocuSignRole varchar(50)
	,
	Tag varchar(100)
	,
	TagType varchar(100)
	,
	GroupName varchar(100)
	,
	IsRequired bit not null default(0)
)
go

create index ix_TemplateAdditionalTags_TemplatesID on TemplateAdditionalTags (TemplatesID)
go

grant select
	,insert
	,update
	,delete
	,references
	on TemplateAdditionalTags
	to DeskflowUsers
go