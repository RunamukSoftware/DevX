CREATE PROCEDURE [dbo].[usp_InsertMiscCodeDetails]
    (
     @codeId INT,
     @organizationId UNIQUEIDENTIFIER,
     @sysId UNIQUEIDENTIFIER,
     @category_cd CHAR(4),
     @method_cd NVARCHAR(10),
     @code NVARCHAR(80),
     @verification_sw TINYINT = NULL,
     @int_keystone_cd NVARCHAR(80) = NULL,
     @short_dsc NVARCHAR(100) = NULL,
     @spc_pcs_code CHAR(1) = NULL
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_misc_code]
            ([code_id],
             [organization_id],
             [sys_id],
             [category_cd],
             [method_cd],
             [code],
             [verification_sw],
             [int_keystone_cd],
             [short_dsc],
             [spc_pcs_code]
            )
    VALUES
            (@codeId,
             @organizationId,
             @sysId,
             @category_cd,
             @method_cd,
             @code,
             @verification_sw,
             @int_keystone_cd,
             @short_dsc,
             @spc_pcs_code
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertMiscCodeDetails';

