CREATE PROCEDURE [old].[uspInsertEncounterMapInformation]
    (
        @EncounterXID   NVARCHAR(40),
        @OrganizationID INT,
        @EncounterID    INT,
        @PatientID      INT,
        @SequenceNumber INT,
        @OrgPatientID   INT         = NULL,
        @StatusCode     NCHAR(1)    = NULL,
        @EventCode      NVARCHAR(4) = NULL,
        @AccountID      INT         = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[EncounterMap]
            (
                [EncounterXID],
                [OrganizationID],
                [EncounterID],
                [PatientID],
                [SequenceNumber],
                [OriginalPatientID],
                [StatusCode],
                [EventCode],
                [AccountID]
            )
        VALUES
            (
                @EncounterXID,
                @OrganizationID,
                @EncounterID,
                @PatientID,
                @SequenceNumber,
                @OrgPatientID,
                @StatusCode,
                @EventCode,
                @AccountID
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert Encounter map information.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertEncounterMapInformation';

