-- 1. Declare input variables
DECLARE 
 @ServerName NVARCHAR(50)
,@dbName NVARCHAR(50)
,@InputQuery NVARCHAR(MAX)

-- 2. Drop temp table if exists and create
IF (SELECT Object_ID('tempdb..#tmpSQLStatements')) IS NOT NULL
BEGIN
    DROP TABLE #tmpSQLStatements
END

CREATE TABLE #tmpSQLStatements
(
    RowID INT NOT NULL IDENTITY(1,1), -- primary key column
    ServerName [NVARCHAR](255),
    DatabaseName [NVARCHAR](255),
    TableName [NVARCHAR](255),
    SQLQuery [NVARCHAR](MAX) 
)


-- 3. Get inputs
SELECT 
     @ServerName = 'ESVMUnityDev1'
    ,@dbName =  'dbRKS'

    -- If we have the table name and SQL query handy, then we can directly insert it into the temp table at step 3.2, instead of creating below dynamic query.

    -- 3.1. Dynamic query to execute, for example, to fetch all views from a DB.  
    -- Query should return 4 columns. 
    ,@InputQuery = N'
    SELECT 
     [ServerName] = '''+@ServerName+'''
    ,[DatabaseName] = '''+@dbName+'''
    ,[TableName] = TABLE_SCHEMA+''.''+TABLE_NAME
    ,[SQLQuery] = ''SELECT * FROM ''+TABLE_SCHEMA+''.''+TABLE_NAME
    FROM '+@dbName+'.INFORMATION_SCHEMA.views WITH (NOLOCK)
    WHERE Table_name in (''vwReport'',''vwAttribute'',''vwAttributeMap'')
    '

    -- 3.2. Fetch the table/object names and sql query coresponds to the table
    -- In below case, this query will fetch the view names and select query on view
    INSERT INTO #tmpSQLStatements (ServerName, DatabaseName, TableName, SQLQuery)
    EXEC sp_sqlexec @InputQuery


-- 4. Build the batch commands
SELECT 
     TableName
    ,SQLQuery
    -- Build windows command for creating sql files
    ,[SQLCmd_BuildSQLFile] = 
    N'(echo SET NOCOUNT ON; 
    && echo GO
    && echo:
    && echo SET SHOWPLAN_XML ON; 
    && echo GO
    && echo:
    && echo '+SQLQuery+ N'; 
    && echo GO 
    && echo:
    && echo SET SHOWPLAN_XML OFF; 
    && echo GO
    && echo:)
    > '+'SQLFiles\'+TableName+'.sql'
    -- Build windows command to run sql files and create Queryplan XML 
    ,SQMCmd_RunSQL = N'sqlcmd -S '+ServerName+' -d '+DatabaseName+' -i SQLFiles\'+TableName+'.sql -y0 -o QueryplanXML\'+TableName+'.xml'
FROM #tmpSQLStatements
GO