SELECT SCHEMA_NAME(fk_tab.schema_id)+'.'+fk_tab.name AS [table], 
       COUNT(*) foreign_keys, 
       COUNT(DISTINCT referenced_object_id) referenced_tables
FROM sys.foreign_keys fk
     INNER JOIN sys.tables fk_tab ON fk_tab.object_id = fk.parent_object_id
GROUP BY SCHEMA_NAME(fk_tab.schema_id)+'.'+fk_tab.name
ORDER BY COUNT(*) DESC;