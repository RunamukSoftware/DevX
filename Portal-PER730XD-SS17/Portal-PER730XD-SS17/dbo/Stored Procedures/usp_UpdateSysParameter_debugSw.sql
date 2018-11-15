CREATE PROCEDURE [dbo].[usp_UpdateSysParameter_debugSw] (@debug_sw TINYINT)
AS
BEGIN
    UPDATE
        [dbo].[int_system_parameter]
    SET
        [debug_sw] = @debug_sw
    WHERE
        [system_parameter_id] IN (1, 2, 3, 5, 6, 7, 8, 9, 11, 12, 14);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateSysParameter_debugSw';

