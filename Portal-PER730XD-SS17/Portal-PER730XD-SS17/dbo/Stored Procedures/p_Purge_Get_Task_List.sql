CREATE PROCEDURE [dbo].[p_Purge_Get_Task_List]
AS
BEGIN
    SELECT
        [name],
        [parm_value],
        [debug_sw]
    FROM
        [dbo].[int_system_parameter]
    WHERE
        [active_flag] = 1
    ORDER BY
        [system_parameter_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge - get task list.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge_Get_Task_List';

