CREATE PROCEDURE [HL7].[uspGetLegacyGlobalDataSystemCodes]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[CodeID]           AS [CodeID],
            [imc].[Code]             AS [GlobalDataSystemCode],
            [imc].[ShortDescription] AS [GlobalDataSystemDescription],
            [imc].[KeystoneCode]     AS [GlobalDataSystemUnitOfMeasure]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve the legacy Global Data System (GDS) codes.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyGlobalDataSystemCodes';

