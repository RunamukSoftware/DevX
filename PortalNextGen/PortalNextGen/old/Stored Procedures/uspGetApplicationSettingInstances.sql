CREATE PROCEDURE [old].[uspGetApplicationSettingInstances] @applicationType VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [as].[InstanceID]
        FROM
            [old].[ApplicationSetting] AS [as]
        WHERE
            [as].[ApplicationType] = @applicationType;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieve all Instance Ids for a given ApplicationSettings Application Type.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetApplicationSettingInstances';

