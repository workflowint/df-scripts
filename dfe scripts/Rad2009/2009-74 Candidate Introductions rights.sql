ALTER TABLE dbo.GroupPermissions ADD
	CandIntroductions_edit bit NULL,
	CandIntroductions_del bit NULL
GO
UPDATE GroupPermissions set CandIntroductions_edit = 1, CandIntroductions_del = 1