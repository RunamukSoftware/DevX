CREATE PROCEDURE [old].[uspSetTask]
    (
        @TaskName NVARCHAR(30),
        @TaskVal  NVARCHAR(30)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[SystemParameter]
        SET
            [ParameterValue] = @TaskVal
        WHERE
            [Name] = @TaskName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSetTask';

