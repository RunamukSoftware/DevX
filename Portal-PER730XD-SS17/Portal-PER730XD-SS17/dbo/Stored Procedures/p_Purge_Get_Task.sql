CREATE PROCEDURE [dbo].[p_Purge_Get_Task] (@TaskName NVARCHAR(30))
AS
BEGIN
    SELECT
        [parm_value]
    FROM
        [dbo].[int_system_parameter]
    WHERE
        [name] = @TaskName;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Get_Task';

