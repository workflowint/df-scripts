ALTER TABLE PowerSearch
ADD [SearchType] [varchar](100) NULL

GO

UPDATE PowerSearch
SET SearchType = 'People' WHERE SearchTableName = 'People'

UPDATE PowerSearch
SET SearchType = 'Company' WHERE SearchTableName = 'Companies'

UPDATE PowerSearch
SET SearchType = 'JobOrder' WHERE SearchTableName = 'JobOrders'

UPDATE PowerSearch
SET SearchType = 'Project' WHERE SearchTableName = 'Projects'

GO

ALTER TABLE PowerSearchCategories
ADD [SearchType] [varchar](100) NULL

GO

UPDATE PowerSearchCategories
SET SearchType = 'People' WHERE SearchTableName = 'People'

UPDATE PowerSearchCategories
SET SearchType = 'Company' WHERE SearchTableName = 'Companies'

UPDATE PowerSearchCategories
SET SearchType = 'JobOrder' WHERE SearchTableName = 'JobOrders'

UPDATE PowerSearchCategories
SET SearchType = 'Project' WHERE SearchTableName = 'Projects'

GO
