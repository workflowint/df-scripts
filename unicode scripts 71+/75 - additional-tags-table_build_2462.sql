if object_id('TemplateAdditionalTags', 'U') is not null
	drop table TemplateAdditionalTags
go

create table TemplateAdditionalTags
(
	TemplateAdditionalTagsID int identity primary key
	,
	TemplatesID int not null
	,
	DocuSignRole nvarchar(50)
	,
	Tag nvarchar(100)
	,
	TagType nvarchar(100)
	,
	GroupName nvarchar(100)
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