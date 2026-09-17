alter table DocuSignRoles add RadioTag nvarchar(100)
alter table DocuSignRoles add CheckboxTag nvarchar(100)
alter table DocuSignRoles add OptionalTextTag nvarchar(100)
alter table DocuSignRoles add OptionalRadioTag nvarchar(100)

alter table LookupTables alter column Visible nvarchar(255)

update LookupTables 
set Editable = Editable + ',OptionalTextTag,CheckboxTag,RadioTag,OptionalRadioTag',
Visible = Visible + ',OptionalTextTag,CheckboxTag,RadioTag,OptionalRadioTag'
where Name = 'DocuSignRoles'


