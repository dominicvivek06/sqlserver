SELECT 
   SCHEMA_NAME(ss.SCHEMA_id) AS SchemaName,
   ss.name as TableName, 
   ss2.name as IndexName, 
   ss2.index_id,
   ss2.type_desc,
   STUFF((SELECT ', ' + name 
          FROM sys.index_columns a INNER JOIN sys.all_columns b ON a.object_id = b.object_id and a.column_id = b.column_id and a.object_id = ss.object_id and a.index_id = ss2.index_id and is_included_column = 0
          ORDER BY a.key_ordinal
          FOR XML PATH('')), 1, 2, '') IndexColumns,
   STUFF((SELECT ', ' + name 
          FROM sys.index_columns a INNER JOIN sys.all_columns b ON a.object_id = b.object_id and a.column_id = b.column_id and a.object_id = ss.object_id and a.index_id = ss2.index_id and is_included_column = 1
          FOR XML PATH('')), 1, 2, '') IncludedColumns
FROM sys.objects SS INNER JOIN sys.indexes ss2 ON ss.OBJECT_ID = ss2.OBJECT_ID 
WHERE ss.type = 'U'
ORDER BY 1, 2, 3 