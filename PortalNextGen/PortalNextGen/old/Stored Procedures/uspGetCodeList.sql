CREATE PROCEDURE [old].[uspGetCodeList]
    (
        @Filters NVARCHAR(MAX),
        @Debug   BIT = 0
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SqlQuery NVARCHAR(MAX);

        SET @SqlQuery
            = '
        SELECT 
            int_organization.OrganizationCode AS [Facility],
            int_send_sys.code AS [System],
            int_misc_code.CategoryCode AS [Category],
            int_misc_code.MethodCode AS [Method], 
            int_misc_code.code AS [Code],
            int_misc_code.KeystoneCode AS [Internal Code],
            int_misc_code.ShortDescription AS [Description], 
            ISNULL(int_misc_code.VerificationSwitch,''0'') AS [Verified],
            int_misc_code.CodeID
        FROM dbo.int_misc_code 
            LEFT OUTER JOIN dbo.int_send_sys 
                ON int_misc_code.SystemID = int_send_sys.SystemID 
            LEFT OUTER JOIN dbo.int_organization 
                ON int_misc_code.OrganizationID = int_organization.OrganizationID 
            ';

        IF (LEN(@Filters) > 0)
            BEGIN
                SET @SqlQuery += 'WHERE ' + @Filters;
            END;

        IF (@Debug = 1)
            PRINT @SqlQuery;

        EXEC (@SqlQuery);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetCodeList';

