CREATE PROCEDURE [old].[uspGetSaveEventArrhythmiaEventTime]
    (
        @PatientID      INT,
        @EventID AS     INT,
        @TimeTagType AS INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isel].[start_ms] AS [STARTMS],
            [isel].[end_ms]   AS [ENDMS]
        FROM
            [Intesys].[SavedEventLog] AS [isel]
        WHERE
            [isel].[PatientID] = @PatientID
            AND [isel].[EventID] = @EventID
            AND [isel].[TimeTagType] = @TimeTagType;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetSaveEventArrhythmiaEventTime';

