CREATE PROCEDURE [old].[uspUpdateVitalLiveTemp]
AS
    BEGIN
        SET NOCOUNT ON;

        -- Create the equivalent date time to (GETDATE( ) - 0.002)
        DECLARE @LowerTimeLimit DATETIME2(7) = DATEADD(MILLISECOND, -172800, SYSUTCDATETIME());

        DELETE
        [ivlt]
        FROM
            [Intesys].[VitalLiveTemporary] AS [ivlt]
        WHERE
            [ivlt].[CreatedDateTime] < @LowerTimeLimit;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateVitalLiveTemp';

