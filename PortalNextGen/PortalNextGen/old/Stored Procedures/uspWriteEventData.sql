CREATE PROCEDURE [old].[uspWriteEventData]
    (
        @UserID     INT,
        @PatientID  INT,
        @Type       INT,
        @NumEvents  INT,
        @EventData  VARBINARY(MAX),
        @SampleRate SMALLINT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[AnalysisEvent]
            (
                [UserID],
                [PatientID],
                [Type],
                [NumberOfEvents],
                [SampleRate],
                [EventData]
            )
        VALUES
            (
                @UserID, @PatientID, @Type, @NumEvents, @SampleRate, @EventData
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteEventData';

