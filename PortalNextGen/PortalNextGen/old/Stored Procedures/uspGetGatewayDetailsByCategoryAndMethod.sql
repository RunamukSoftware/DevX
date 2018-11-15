CREATE PROCEDURE [old].[uspGetGatewayDetailsByCategoryAndMethod]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[CodeID],
            [imc].[OrganizationID],
            [imc].[SystemID],
            [imc].[CategoryCode],
            [imc].[MethodCode],
            [imc].[Code],
            [imc].[VerificationSwitch],
            [imc].[KeystoneCode],
            [imc].[ShortDescription],
            [imc].[spc_pcs_code]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[CategoryCode] = 'USID'
            AND [imc].[MethodCode] = N'GDS'
        ORDER BY
            [imc].[Code];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetGatewayDetailsByCategoryAndMethod';

