CREATE PROCEDURE [old].[uspDeleteUnitSetting] (@UnitID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [Configuration].[ValueUnit]
        WHERE
            [UnitID] = @UnitID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteUnitSetting';

