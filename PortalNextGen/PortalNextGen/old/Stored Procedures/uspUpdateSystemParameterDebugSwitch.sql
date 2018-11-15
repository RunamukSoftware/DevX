CREATE PROCEDURE [old].[uspUpdateSystemParameterDebugSwitch] (@DebugSwitch BIT)
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[SystemParameter]
        SET
            [DebugSwitch] = @DebugSwitch
        WHERE
            [SystemParameterID] IN (
                                       1, 2, 3, 5, 6, 7, 8, 9, 11, 12, 14
                                   );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateSystemParameterDebugSwitch';

