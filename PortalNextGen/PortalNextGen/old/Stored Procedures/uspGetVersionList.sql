CREATE PROCEDURE [old].[uspGetVersionList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [VersionCode],
            [InstallDateTime],
            [StatusCode],
            [InstallProgram]
        FROM
            [Configuration].[DatabaseVersion];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetVersionList';

