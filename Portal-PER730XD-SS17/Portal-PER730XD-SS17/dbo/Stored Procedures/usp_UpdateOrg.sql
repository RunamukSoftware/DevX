CREATE PROCEDURE [dbo].[usp_UpdateOrg]
    (
     @organizationCd NVARCHAR(20),
     @organizationNm NVARCHAR(50),
     @organizationId UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_organization]
    SET
        [organization_cd] = @organizationCd,
        [organization_nm] = @organizationNm
    WHERE
        [organization_id] = @organizationId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateOrg';

