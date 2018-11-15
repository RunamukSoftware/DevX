
CREATE FUNCTION dbo.ListOutTableEPs
  /**
  Summary: >
    List out all the constraints, indexes, columns and triggers
    of a table in column order 
  Author: Phil Factor
  Date: 12/12/2017
  Database: PhilFactor
  Examples:
     - Select * from dbo.ListOutTableEPs('dbo.person')
     - >
     SELECT Object_Schema_Name(constraints.object_id) + '.'
         + Object_Name(constraints.object_id) AS [table],
      constraints.name AS name, ChildType AS type, Value AS doc
      FROM dbo.ListOutTableEPs('dbo.person') AS constraints
      ORDER BY column_id, childtype
     FOR JSON AUTO;
  Returns: >
    A table listing all the EPs of type MS_Description if any applied to the children 
    of the table  name, object_id, column_id, value  
    note that the column_id is only relevant for columns and column-based constraints. It 
    is mostly used for conveniently ordering the JSON result the same as the build script
    ChildType can be COLUMN, CONSTRAINT, INDEX, (not yet TRIGGER, and NULL).
          **/
    (
    @Tablename NVarchar(100)
    )
  RETURNS TABLE
   --WITH ENCRYPTION|SCHEMABINDING, ..
  AS
  RETURN
    (
    SELECT ---first we do columns
        col.name, --the name of the database thing
  	  col.object_id,--the object it belongs to
  	  col.column_id,--the column associated with it - used to sort in column order 
        Coalesce(Convert(NVARCHAR(4000), ep.value), '') AS value,--the documentation 
  	  Convert(VARCHAR(20),'column') AS ChildType -- section is about columns
      FROM sys.columns AS col --the columns
        INNER JOIN sys.objects -- associated with the table 
          ON objects.object_id = col.object_id 
    	    AND objects.object_id=Object_Id(@Tablename,'U') --just the one
        LEFT OUTER JOIN sys.extended_properties AS ep --and pick up any existing documentation
          ON ep.major_id = col.object_id AND ep.class = 1 
    	    AND ep.minor_id = col.column_id
    		AND ep.name='MS_Description' --the microsoft convention
    UNION ALL
    SELECT -- Next we do indexes
      child.name, parent.object_id, 1000, 
  	Coalesce(Convert(NVARCHAR(100), ep.value), ''), 'Index'
      FROM sys.indexes AS child --indexes are treated in a very similar way 
        INNER JOIN sys.objects AS parent
          ON child.object_id = parent.object_id
        LEFT OUTER JOIN sys.extended_properties AS ep
          ON ep.major_id = child.object_id 
    	  AND ep.minor_id = child.index_id AND ep.class = 7
    	  AND ep.name='MS_Description'--the microsoft convention
      WHERE parent.object_id=Object_Id(@Tablename,'U')
    UNION all
    SELECT 
        child.name, 
        parent.object_id, 
    	Coalesce(DC.parent_column_id, cC.parent_column_id, 1000), 
    	Coalesce(Convert(NVARCHAR(100), ep.value), ''),
    	CASE WHEN child.type_desc LIKE '%constraint' 
    	   THEN 'constraint' 
    	   ELSE Lower(Replace(child.type_desc,'SQL_','')) end
      FROM sys.objects AS child
        INNER JOIN sys.objects AS parent
          ON child.parent_object_id = parent.object_id
  	--we need to gather up information like column and whether
  	--they are system-generated (who would want to docuement them
        LEFT OUTER JOIN sys.default_constraints AS DC
          ON DC.object_id = child.object_id -- to get column
        LEFT OUTER JOIN sys.check_constraints AS cC
          ON cC.object_id = child.object_id --to get column
        LEFT OUTER JOIN sys.key_constraints AS KC
          ON KC.object_id = child.object_id --to get column
  	  LEFT OUTER JOIN sys.foreign_keys AS FK 
          ON FK.object_id = child.object_id --to get column
  	  LEFT OUTER JOIN sys.extended_properties AS ep
          ON ep.major_id = child.object_id AND class=1
    	  AND ep.name='MS_Description'--the microsoft convention
      WHERE parent.object_id=Object_Id(@Tablename,'U') 
  	AND Coalesce(DC.is_system_named,0)+
          Coalesce(KC.is_system_named,0)+
          Coalesce(FK.is_system_named,0)+
          Coalesce(cC.is_system_named,0) = 0
  	--leave out system-generated constraints
    )