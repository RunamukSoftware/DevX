CREATE PROCEDURE [old].[uspWriteTwelveLeadData]
    (
        @PatientID      INT,
        @ReportID       INT,
        @ReportDateTime DATETIME2(7),
        @VersionNumber  SMALLINT,
        @PatientName    VARCHAR(50),
        @IdNum          VARCHAR(20),
        @BirthDate      DATE,
        @Age            VARCHAR(15),
        @Sex            CHAR(1),
        @Height         VARCHAR(15),
        @Weight         VARCHAR(15),
        @VentRate       INT,
        @PRInterval     INT,
        @QT             INT,
        @QTC            INT,
        @QRSDuration    INT,
        @PAxis          INT,
        @QRSAxis        INT,
        @TAxis          INT,
        @Interpretation NVARCHAR(MAX),
        @SampleRate     INT,
        @SampleCount    INT,
        @NumYPoints     INT,
        @Baseline       INT,
        @YPointsPerUnit INT,
        @WaveformData   VARBINARY(MAX)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[TwelveLeadReportNew]
            (
                [PatientID],
                [ReportID],
                [ReportDateTime],
                [VersionNumber],
                [PatientName],
                [IDNumber],
                [BirthDate],
                [Age],
                [Gender],
                [Height],
                [Weight],
                [VentRate],
                [PrInterval],
                [Qt],
                [Qtc],
                [QrsDuration],
                [PAxis],
                [QrsAxis],
                [TAxis],
                [Interpretation],
                [SampleRate],
                [SampleCount],
                [NumberOfYPoints],
                [Baseline],
                [YPointsPerUnit],
                [WaveformData]
            )
        VALUES
            (
                @PatientID,
                @ReportID,
                @ReportDateTime,
                @VersionNumber,
                @PatientName,
                @IdNum,
                @BirthDate,
                @Age,
                @Sex,
                @Height,
                @Weight,
                @VentRate,
                @PRInterval,
                @QT,
                @QTC,
                @QRSDuration,
                @PAxis,
                @QRSAxis,
                @TAxis,
                @Interpretation,
                @SampleRate,
                @SampleCount,
                @NumYPoints,
                @Baseline,
                @YPointsPerUnit,
                @WaveformData
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteTwelveLeadData';

