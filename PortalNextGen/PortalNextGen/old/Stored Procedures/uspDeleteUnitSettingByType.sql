CREATE PROCEDURE [old].[uspDeleteUnitSettingByType]
    (
        @UnitID            INT,
        @TypeCode          VARCHAR(25),
        @ConfigurationName VARCHAR(40)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [Configuration].[ValueUnit]
        WHERE
            [UnitID] = @UnitID
            AND [TypeCode] = @TypeCode
            AND [ConfigurationName] = @ConfigurationName;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteUnitSettingByType';

