CREATE PROCEDURE [DM3].[uspGetCodeID]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[CodeID],
            [imc].[Code]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[OrganizationID] IS NULL
            AND [imc].[Code] IS NOT NULL;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetCodeID';

