CREATE PROCEDURE [old].[uspGetVersionNumber]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT TOP (1)
            [idv].[VersionCode],
            [idv].[InstallDateTime]
        FROM
            [Configuration].[DatabaseVersion] AS [idv]
        ORDER BY
            [idv].[InstallDateTime] DESC,
            [idv].[CreatedDateTime] DESC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Returns the latest version number of the ICS database using the new CreateDate column to break the possible tie.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetVersionNumber';

