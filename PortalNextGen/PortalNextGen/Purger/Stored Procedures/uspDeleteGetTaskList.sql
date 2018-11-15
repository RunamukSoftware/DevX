CREATE PROCEDURE [Purger].[uspDeleteGetTaskList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isp].[Name],
            [isp].[ParameterValue],
            [isp].[DebugSwitch]
        FROM
            [Intesys].[SystemParameter] AS [isp]
        WHERE
            [isp].[ActiveFlag] = 1
        ORDER BY
            [isp].[SystemParameterID];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Purge - get task list.', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteGetTaskList';

