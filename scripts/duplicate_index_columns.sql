SELECT t1.tablename, t1.indexname ,t1.columnlist, t2.indexname, t2.columnlist 
FROM
   (SELECT 
      DISTINCT object_name(i.object_id) tablename, 
      i.name indexname,
      (SELECT DISTINCT STUFF( (SELECT ', ' + c.name
                               FROM sys.index_columns ic1 
                               INNER JOIN sys.columns c ON ic1.object_id=c.object_id AND ic1.column_id=c.column_id
                               WHERE 
                                     ic1.index_id = ic.index_id 
                                 AND ic1.object_id=i.object_id
                                 AND ic1.index_id=i.index_id
                               ORDER BY index_column_id FOR XML PATH('')
                              ),1,2,'')
       FROM sys.index_columns ic 
       WHERE object_id=i.object_id AND index_id=i.index_id
     ) as columnlist
   FROM sys.indexes i 
   INNER JOIN sys.index_columns ic ON i.object_id=ic.object_id AND i.index_id=ic.index_id 
   INNER JOIN sys.objects o ON i.object_id=o.object_id 
   WHERE o.is_ms_shipped=0) t1 
INNER JOIN 
   (SELECT 
      DISTINCT object_name(i.object_id) tablename,
      i.name indexname,
     (SELECT DISTINCT STUFF( (SELECT ', ' + c.name
                              FROM sys.index_columns ic1 
                              INNER JOIN sys.columns c ON ic1.object_id=c.object_id AND ic1.column_id=c.column_id
                              WHERE 
                                    ic1.index_id = ic.index_id 
                                AND ic1.object_id=i.object_id 
                                AND ic1.index_id=i.index_id
                              ORDER BY index_column_id FOR XML PATH('')
                             ),1,2,'')
      FROM sys.index_columns ic 
      WHERE object_id=i.object_id AND index_id=i.index_id
     ) as columnlist
    FROM sys.indexes i 
    INNER JOIN sys.index_columns ic ON i.object_id=ic.object_id AND i.index_id=ic.index_id 
    INNER JOIN sys.objects o ON i.object_id=o.object_id 
    WHERE o.is_ms_shipped=0) t2 
 ON t1.tablename=t2.tablename 
AND substring(t2.columnlist,1,len(t1.columnlist))=t1.columnlist 
AND (t1.columnlist<>t2.columnlist or (t1.columnlist=t2.columnlist AND t1.indexname<>t2.indexname))