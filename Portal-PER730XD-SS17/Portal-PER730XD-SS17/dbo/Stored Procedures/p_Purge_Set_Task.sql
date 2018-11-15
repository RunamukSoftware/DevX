CREATE PROCEDURE [dbo].[p_Purge_Set_Task]
    (
     @TaskName NVARCHAR(30),
     @TaskVal NVARCHAR(30)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_system_parameter]
    SET
        [parm_value] = @TaskVal
    WHERE
        [name] = @TaskName;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Set_Task';

