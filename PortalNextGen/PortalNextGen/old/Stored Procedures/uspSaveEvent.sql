CREATE PROCEDURE [old].[uspSaveEvent]
    @UserID                INT,
    @PatientID             INT,
    @EventID               INT,
    @InsertDateTime        DATETIME2(7),
    @OriginalEventCategory INT,
    @StartDateTime         DATETIME2(7),
    @StartMilliseconds     INT,
    @Duration              INT,
    @Print_format          INT,
    @Title                 NVARCHAR(50),
    @Comment               NVARCHAR(200),
    @AnnotateData          TINYINT,
    @BeatColor             TINYINT,
    @NumberOfWaveforms     INT,
    @SweepSpeed            INT,
    @MinutesPerPage        INT,
    @ThumbnailChannel      INT
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[PatientSavedEvent]
            (
                [PatientID],
                [EventID],
                [InsertDateTime],
                [UserID],
                [OriginalEventCategory],
                [OriginalEventType],
                [StartDateTime],
                [StartMilliseconds],
                [Duration],
                [Value1],
                [Value2],
                [PrintFormat],
                [Title],
                [Comment],
                [AnnotateData],
                [BeatColor],
                [NumberOfWaveforms],
                [SweepSpeed],
                [MinutesPerPage],
                [ThumbnailChannel]
            )
        VALUES
            (
                @PatientID,
                @EventID,
                @InsertDateTime,
                @UserID,
                @OriginalEventCategory,
                -1, -- [OriginalEventType]
                @StartDateTime,
                @StartMilliseconds,
                @Duration,
                0,  -- [Value1] [int] NOT NULL,
                0,  -- [Value2] INT NULL,
                @Print_format,
                @Title,
                @Comment,
                @AnnotateData,
                @BeatColor,
                @NumberOfWaveforms,
                @SweepSpeed,
                @MinutesPerPage,
                @ThumbnailChannel
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEvent';

