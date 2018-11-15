CREATE PROCEDURE [old].[uspDeletePatientSavedEvent]
    (
        @PatientID INT,
        @EventID   INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [ise]
        FROM
            [Intesys].[PatientSavedEvent] AS [ise]
        WHERE
            [ise].[PatientID] = @PatientID
            AND [ise].[EventID] = @EventID;

        DELETE
        [isew]
        FROM
            [Intesys].[SavedEventWaveform] AS [isew]
        WHERE
            [isew].[PatientID] = @PatientID
            AND [isew].[EventID] = @EventID;

        DELETE
        [isebtl]
        FROM
            [Intesys].[SavedEventBeatTimeLog] AS [isebtl]
        WHERE
            [isebtl].[PatientID] = @PatientID
            AND [isebtl].[EventID] = @EventID;

        DELETE
        [isec]
        FROM
            [Intesys].[SavedEventCalipers] AS [isec]
        WHERE
            [isec].[PatientID] = @PatientID
            AND [isec].[EventID] = @EventID;

        DELETE
        [iseel]
        FROM
            [Intesys].[SavedEventLog] AS [iseel]
        WHERE
            [iseel].[PatientID] = @PatientID
            AND [iseel].[EventID] = @EventID;

        DELETE
        [isev]
        FROM
            [Intesys].[SavedEventVital] AS [isev]
        WHERE
            [isev].[PatientID] = @PatientID
            AND [isev].[EventID] = @EventID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeletePatientSavedEvent';

