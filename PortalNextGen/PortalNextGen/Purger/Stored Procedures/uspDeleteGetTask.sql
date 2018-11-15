CREATE PROCEDURE [Purger].[uspDeleteGetTask] (@TaskName NVARCHAR(30))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isp].[ParameterValue]
        FROM
            [Intesys].[SystemParameter] AS [isp]
        WHERE
            [isp].[Name] = @TaskName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteGetTask';

