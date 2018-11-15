CREATE PROCEDURE [DM3].[uspUpdateLastPoleDateResultDateInPatientMonitor]
    (
        @LastPollDateTime DATETIME2(7) = NULL,
        @PatientID        INT,
        @PatientMonitorID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[PatientMonitor]
        SET
            [LastPollingDateTime] = @LastPollDateTime,
            [LastResultDateTime] = @LastPollDateTime
        WHERE
            [PatientID] = @PatientID
            AND [PatientMonitorID] = @PatientMonitorID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspUpdateLastPoleDateResultDateInPatientMonitor';

