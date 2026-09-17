alter table DocuSignRoles add RadioTag varchar(100)
alter table DocuSignRoles add CheckboxTag varchar(100)
alter table DocuSignRoles add OptionalTextTag varchar(100)
alter table DocuSignRoles add OptionalRadioTag varchar(100)

alter table LookupTables alter column Visible varchar(255)

update LookupTables 
set Editable = Editable + ',OptionalTextTag,CheckboxTag,RadioTag,OptionalRadioTag',
Visible = Visible + ',OptionalTextTag,CheckboxTag,RadioTag,OptionalRadioTag'
where Name = 'DocuSignRoles'


