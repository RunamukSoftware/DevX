CREATE PROCEDURE [old].[uspDeleteMiscellaneousCode] (@CodeID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [imc]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [CodeID] = @CodeID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteMiscellaneousCode';

