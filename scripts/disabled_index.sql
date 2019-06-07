DECLARE @is_disabled bit = 0 -- 1=disabled  0=enabled

SELECT 
   SCHEMA_NAME(ss.SCHEMA_id) AS SchemaName,
   ss.name AS TableName,
   ss2.index_id AS IndexID,
   ss2.name AS IndexName, 
   ss2.type_desc AS IndexType, 
   CASE ss2.is_disabled  
      WHEN 0 THEN 'Enabled' 
      ELSE 'Disabled'  
   END AS IndexStatus,  
   ss2.fill_factor AS [FillFactor] 
FROM sys.objects SS INNER JOIN sys.indexes ss2 ON ss.OBJECT_ID = ss2.OBJECT_ID 
WHERE ss.is_ms_shipped = 0
  AND ss2.is_disabled = @is_disabled 
GO