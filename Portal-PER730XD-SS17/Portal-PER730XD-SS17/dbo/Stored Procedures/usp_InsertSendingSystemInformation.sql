CREATE PROCEDURE [dbo].[usp_InsertSendingSystemInformation]
    (
     @SysId UNIQUEIDENTIFIER,
     @OrganizationId UNIQUEIDENTIFIER,
     @code NVARCHAR(180),
     @dsc NVARCHAR(180)
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
            (@SysId,
             @OrganizationId,
             @code,
             @dsc
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the sending system details.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertSendingSystemInformation';

