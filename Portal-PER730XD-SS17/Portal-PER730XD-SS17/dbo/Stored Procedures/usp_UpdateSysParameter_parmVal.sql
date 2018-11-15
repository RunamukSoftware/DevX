CREATE PROCEDURE [dbo].[usp_UpdateSysParameter_parmVal]
    (
     @parm_value NVARCHAR(80),
     @name NVARCHAR(30)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_system_parameter]
    SET
        [parm_value] = @parm_value
    WHERE
        UPPER([name]) = @name; --TG-Why UPPER??
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateSysParameter_parmVal';

