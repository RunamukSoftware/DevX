CREATE PROCEDURE [dbo].[usp_DeleteSendSys]
    (
     @sys_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE FROM
        [dbo].[int_send_sys]
    WHERE
        [sys_id] = @sys_id; 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DeleteSendSys';

