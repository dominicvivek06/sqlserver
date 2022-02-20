IF OBJECT_ID('tempdb.dbo.#dict') IS NOT NULL 
DROP 
  TABLE #dict
  CREATE TABLE #dict
  (
    [db_name] SYSNAME, 
    TABLE_SCHEMA SYSNAME, 
    TABLE_NAME SYSNAME, 
    COLUMN_NAME SYSNAME, 
    ORDINAL_POSITION INT NULL, 
    COLUMN_DEFAULT nvarchar(4000) NULL, 
    DATA_TYPE SYSNAME NULL, 
    CHARACTER_MAXIMUM_LENGTH INT NULL, 
    NUMERIC_PRECISION INT NULL, 
    NUMERIC_PRECISION_RADIX INT NULL, 
    NUMERIC_SCALE INT NULL, 
    DATETIME_PRECISION INT NULL
  ) DECLARE @SQL NVARCHAR(MAX) 
SELECT 
  @SQL = STUFF(
    (
      SELECT 
        '
    USE [' + d.name + ']
    INSERT INTO #dict ([db_name], TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,ORDINAL_POSITION,COLUMN_DEFAULT,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION,NUMERIC_PRECISION_RADIX,NUMERIC_SCALE, DATETIME_PRECISION )
    
SELECT DB_NAME(),TABLE_SCHEMA , TABLE_NAME,COLUMN_NAME,ORDINAL_POSITION,COLUMN_DEFAULT,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION,NUMERIC_PRECISION_RADIX,NUMERIC_SCALE, DATETIME_PRECISION FROM INFORMATION_SCHEMA.COLUMNS' 
      FROM 
        sys.databases d 
      WHERE 
        d.[state] = 0 
        and d.database_id > 4 FOR XML PATH(''), 
        TYPE
    ).value('.', 'NVARCHAR(MAX)'), 
    1, 
    2, 
    ''
  ) EXEC sys.sp_executesql @SQL 
SELECT 
  * 
FROM 
  #dict
order by 
  db_name, 
  TABLE_SCHEMA, 
  TABLE_NAME, 
  ORDINAL_POSITION
