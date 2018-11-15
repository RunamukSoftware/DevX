CREATE PROCEDURE [dbo].[usp_InsertSendSysDetails]
    (
     @sys_id UNIQUEIDENTIFIER,
     @organization_id UNIQUEIDENTIFIER,
     @code NVARCHAR(30),
     @dsc NVARCHAR(80)
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_send_sys]
            ([sys_id],
             [organization_id],
             [code],
             [dsc]
            )
    VALUES
            (@sys_id,
             @organization_id,
             @code,
             @dsc
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertSendSysDetails';

