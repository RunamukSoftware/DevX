CREATE PROCEDURE [old].[uspUpdateSystemParameterValue]
    (
        @Name           NVARCHAR(30),
        @ParameterValue NVARCHAR(80)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[SystemParameter]
        SET
            [ParameterValue] = @ParameterValue
        WHERE
            [Name] = @Name;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateSystemParameterValue';

