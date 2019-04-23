SELECT tab AS [table], 
       COUNT(DISTINCT rel_name) AS relationships, 
       COUNT(DISTINCT fk_name) AS foreign_keys, 
       COUNT(DISTINCT ref_name) AS [references], 
       COUNT(DISTINCT rel_object_id) AS related_tables, 
       COUNT(DISTINCT referenced_object_id) AS referenced_tables, 
       COUNT(DISTINCT parent_object_id) AS referencing_tables
FROM
(
    SELECT SCHEMA_NAME(tab.schema_id)+'.'+tab.name AS tab, 
           fk.name AS rel_name, 
           fk.referenced_object_id AS rel_object_id, 
           fk.name AS fk_name, 
           fk.referenced_object_id, 
           NULL AS ref_name, 
           NULL AS parent_object_id
    FROM sys.tables AS tab
         LEFT JOIN sys.foreign_keys AS fk ON tab.object_id = fk.parent_object_id
    UNION ALL
    SELECT SCHEMA_NAME(tab.schema_id)+'.'+tab.name AS tab, 
           fk.name AS rel_name, 
           fk.parent_object_id AS rel_object_id, 
           NULL AS fk_name, 
           NULL AS referenced_object_id, 
           fk.name AS ref_name, 
           fk.parent_object_id
    FROM sys.tables AS tab
         LEFT JOIN sys.foreign_keys AS fk ON tab.object_id = fk.referenced_object_id
) q
GROUP BY tab
ORDER BY COUNT(DISTINCT rel_name) DESC;