CREATE PROCEDURE [old].[uspGetCodeIDByName] (@ShortDescription NVARCHAR(100))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[CodeID]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[ShortDescription] = @ShortDescription;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetCodeIDByName';

