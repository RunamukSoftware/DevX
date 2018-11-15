CREATE PROCEDURE [old].[uspGetGender]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [imc].[ShortDescription]
        FROM
            [Intesys].[MiscellaneousCode] AS [imc]
        WHERE
            [imc].[CategoryCode] = 'SEX'
            AND [imc].[VerificationSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetGender';

