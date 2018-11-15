CREATE PROCEDURE [dbo].[DeleteUnitSetting]
    (
     @UnitID UNIQUEIDENTIFIER
    )
AS
BEGIN
    DELETE FROM
        [dbo].[cfgValuesUnit]
    WHERE
        [unit_id] = @UnitID;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteUnitSetting';

