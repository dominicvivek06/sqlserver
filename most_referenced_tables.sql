SELECT SCHEMA_NAME(tab.schema_id)+'.'+tab.name AS [table], 
       COUNT(fk.name) AS [references], 
       COUNT(DISTINCT fk.parent_object_id) AS referencing_tables
FROM sys.tables AS tab
     LEFT JOIN sys.foreign_keys AS fk ON tab.object_id = fk.referenced_object_id
GROUP BY SCHEMA_NAME(tab.schema_id), 
         tab.name
HAVING COUNT(fk.name) > 0
ORDER BY 2 DESC;