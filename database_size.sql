SELECT DB_NAME(database_id) AS 'DB Name', 
       [Type] = CASE
                    WHEN Type_Desc = 'ROWS'
                    THEN 'Data File'
                    WHEN Type_Desc = 'LOG'
                    THEN 'Log File'
                    ELSE Type_Desc
                END, 
       CAST(((SUM(Size) * 8) / 1024.0) AS DECIMAL(18, 2)) AS 'Size in MB', 
	     CAST(((SUM(Size) * 8) / 1024.0 / 1024.0) AS DECIMAL(18, 2)) AS 'Size in GB', 
       physical_name
FROM sys.master_files
GROUP BY DB_NAME(database_id), 
         physical_name, 
         Type_Desc
ORDER BY DB_NAME(database_id), 
         Type_Desc DESC;