CREATE PROCEDURE [old].[uspGetRawECGData]
    (
        @PatientID     INT,
        @ChannelTypeID VARCHAR(40),
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @ChannelIDs AS [old].[utpStringList];

        INSERT INTO @ChannelIDs
            (
                [Item]
            )
        VALUES
            (
                @ChannelTypeID
            );

        EXEC [ClinicalAccess].[uspGetPatientWaveForms]
            @PatientID = @PatientID,
            @ChannelIDs = @ChannelIDs,
            @StartDateTime = @StartDateTime,
            @EndDateTime = @EndDateTime;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetRawECGData';

