CREATE PROCEDURE [dbo].[DeleteUnitSettingByType]
    (
     @UnitID UNIQUEIDENTIFIER,
     @TypeCd VARCHAR(25),
     @CfgName VARCHAR(40)
    )
AS
BEGIN
    DELETE FROM
        [dbo].[cfgValuesUnit]
    WHERE
        [unit_id] = @UnitID
        AND [type_cd] = @TypeCd
        AND [cfg_name] = @CfgName;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteUnitSettingByType';

