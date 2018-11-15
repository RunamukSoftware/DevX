
CREATE FUNCTION [dbo].[ScriptOutExtendedProperties]
    /**
  Summary: >
    This function  will script out all Extended Properties
    of the table you specify
  Author: PhilFactor
  Date: 08/12/2017
  Parameters: 
       - @TableName sysname--the name of the table with optional schema
       - @option --default 'all', has the existing documentation. 'none' leaves them blank 
  Examples:
     - Select * from dbo.ScriptOutExtendedProperties('person',Default)
     - Select * from dbo.ScriptOutExtendedProperties('person','none')
     - Select * from dbo.ScriptOutExtendedProperties('humanresources.employee',Default)
  Returns: >
    A one-row table containing a column with the build script
          **/
    (@TableName sysname,
     @option VARCHAR(10) = 'all')
RETURNS TABLE
--WITH ENCRYPTION|SCHEMABINDING, ..
AS
RETURN (SELECT
            --we start out by inserting the part of the script that will create a script for
            --each extended property. It will put the results in a variable called '@TheScript'
            '-- create all the Extended Properties
    DECLARE @TheScript NVARCHAR(MAX) =
      (SELECT ''EXEC sys.sp_addextendedproperty @name = N''''MS_Description'''',  
            @value = N''''''+ Replace(Explanation,'''''''','''''''''''') + '''''',
      @level0type =  N''''SCHEMA'''', @level0name = N'''''' + 
            Replace(theSchema,'''''''','''''''''''')  + '''''',
      @level1type = N''''TABLE'''',  @level1name = N'''''' + 
            Replace(TheTable,'''''''','''''''''''')  + '''''', 
      @level2type = N'''''' + Replace(TheChildObject,'''''''','''''''''''')  + '''''', 
            @level2name = N'''''' + Replace(ColumnName,'''''''','''''''''''')  + '''''';
     '' 
      FROM
             (VALUES
    ' +
            --now we create the table source that actually lists all the Extended Properties 
            --whether they are filled in or not   
            STUFF --
            (
                (SELECT [lines].[Thesql]
                 FROM (SELECT --  name  object_id  column_id  value
                           [column_id],
                           [Descriptions].[name] AS [The_object_name],
                           ',
       (''' +           REPLACE([Descriptions].[name], '''', '''''') + ''','''
                           + REPLACE(COALESCE([Descriptions].[value], ''), '''', '''''') + ''','''
                           + REPLACE(OBJECT_SCHEMA_NAME([Descriptions].[object_id]), '''', '''''') + ''','''
                           + REPLACE(OBJECT_NAME([Descriptions].[object_id]), '''', '''''') + ''','''
                           + REPLACE([Descriptions].[ChildType], '''', '''''') + ''')' AS [Thesql]
                       FROM [dbo].[ListOutTableEPs](@TableName) AS [Descriptions]
                       WHERE [Descriptions].[value] = CASE
                                                          WHEN @option = 'all'
                                                              THEN
                                                              [Descriptions].[value]
                                                          ELSE
                                                              ''
                                                      END) AS [lines]([column_id], [The_object_name], [Thesql])
                 ORDER BY [lines].[column_id],
                          [lines].[The_object_name]
                FOR XML PATH(''), TYPE).[value]('.', 'varchar(max)'),
                1,
                1,
                '')
--and now we put in the final part of the code that executes the string
+           '
     	   ) AS Properties(ColumnName, Explanation, theSchema, TheTable,TheChildObject)
     WHERE Coalesce(explanation,'''')<>''''
     FOR XML PATH (''''), TYPE).value(''.'', ''varchar(max)'')
     EXEC sys.sp_executesql  @stmt = @TheScript 
     --Run time-compiled Transact-SQL statements can expose applications to malicious attacks.
     '      AS [TheScript]);