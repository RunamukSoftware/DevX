CREATE PROCEDURE [dbo].[usp_UpdateMiscCode]
    (
     @organization_id UNIQUEIDENTIFIER,
     @sys_id UNIQUEIDENTIFIER,
     @category_cd CHAR(4),
     @method_cd NVARCHAR(10),
     @code NVARCHAR(80),
     @int_keystone_cd NVARCHAR(80),
     @short_dsc NVARCHAR(100),
     @verification_sw TINYINT,
     @code_id INT
    )
AS
BEGIN
    UPDATE
        [dbo].[int_misc_code]
    SET
        [organization_id] = @organization_id,
        [sys_id] = @sys_id,
        [category_cd] = @category_cd,
        [method_cd] = @method_cd,
        [code] = @code,
        [int_keystone_cd] = @int_keystone_cd,
        [short_dsc] = @short_dsc,
        [verification_sw] = @verification_sw
    WHERE
        [code_id] = @code_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateMiscCode';

