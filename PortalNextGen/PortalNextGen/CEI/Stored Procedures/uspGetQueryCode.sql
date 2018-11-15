CREATE PROCEDURE [CEI].[uspGetQueryCode]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[CodeID],
            [imc].[ShortDescription],
            [imc].[KeystoneCode]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[MethodCode] = N'GDS'
            AND [imc].[VerificationSwitch] IS NOT NULL
            AND [imc].[ShortDescription] IS NOT NULL;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'CEI', @level1type = N'PROCEDURE', @level1name = N'uspGetQueryCode';

