CREATE PROCEDURE [old].[uspSaveEventLeadLog]
    (
        @PatientID         INT,
        @EventID           INT,
        @PrimaryChannel AS BIT,
        @TimeTagType       INT,
        @lead_type         INT,
        @start_ms          INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[SavedEventLog]
            (
                [PatientID],
                [EventID],
                [PrimaryChannel],
                [TimeTagType],
                [LeadType],
                [start_ms]
            )
        VALUES
            (
                @PatientID, @EventID, @PrimaryChannel, @TimeTagType, @lead_type, @start_ms
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEventLeadLog';

