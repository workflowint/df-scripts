declare @CatalogName varchar(255)
declare @TableName varchar(255)
declare @IndexName varchar(255)
declare @ColumnName varchar(255)
declare @SQLString1 varchar(1000)
declare CurRow cursor local static for
select QUOTENAME(cat.name), QUOTENAME(tbl.name), 
        QUOTENAME(col.name), QUOTENAME(pk.name)
    FROM sys.fulltext_indexes ix
    INNER JOIN sys.fulltext_catalogs cat ON cat.fulltext_catalog_id = ix.fulltext_catalog_id
    INNER JOIN sys.fulltext_index_columns ixc ON ix.object_id = ixc.object_id
    INNER JOIN sys.tables tbl ON tbl.object_id = ix.object_id
    INNER JOIN sys.columns col ON ixc.object_id = col.object_id AND ixc.column_id = col.column_id
    INNER JOIN sys.indexes pk ON ix.object_id = pk.object_id AND ix.unique_index_id = pk.index_id
where tbl.name ='Document'  
order by tbl.name
open CurRow
fetch next from CurRow into @CatalogName,@TableName,@ColumnName,@IndexName
while @@fetch_status = 0
    begin
		  set @SQLString1 ='DROP FULLTEXT INDEX ON '+@TableName
		  EXEC(@SQLString1)
		  set @SQLString1 =' ALTER TABLE '+@TableName+' ALTER COLUMN '+@ColumnName+' varbinary(max)  '
		  EXEC(@SQLString1)
		  set @SQLString1 =' CREATE FULLTEXT INDEX ON ' + @TableName + '(' + @ColumnName + ' TYPE COLUMN FileExtension ) KEY INDEX ' + @IndexName + 
		  ' ON ' + @CatalogName 
		  EXEC(@SQLString1)

      fetch next from CurRow into @CatalogName,@TableName,@ColumnName,@IndexName

    end

close      CurRow
deallocate CurRow
