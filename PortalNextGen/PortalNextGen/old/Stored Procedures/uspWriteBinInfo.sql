CREATE PROCEDURE [old].[uspWriteBinInfo]
    (
        @UserID              INT,
        @PatientID           INT,
        @TemplateSetIndex    INT,
        @TemplateIndex       INT,
        @BinNumber           INT,
        @Source              INT,
        @BeatCount           INT,
        @FirstBeatNumber     INT,
        @NonIgnoredCount     INT,
        @FirstNonIgnoredBeat INT,
        @ISOOffset           INT,
        @STOffset            INT,
        @IPoint              INT,
        @JPoint              INT,
        @STClass             INT,
        @SinglesBin          INT,
        @EditBin             INT,
        @SubclassNumber      INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[BinInformation]
            (
                [UserID],
                [PatientID],
                [TemplateSetIndex],
                [TemplateIndex],
                [BinNumber],
                [Source],
                [BeatCount],
                [FirstBeatNumber],
                [NonIgnoredCount],
                [FirstNonIgnoredBeat],
                [iso_offset],
                [st_offset],
                [i_point],
                [j_point],
                [st_class],
                [SinglesBin],
                [EditBin],
                [SubclassNumber],
                [BinImage]
            )
        VALUES
            (
                @UserID,
                @PatientID,
                @TemplateSetIndex,
                @TemplateIndex,
                @BinNumber,
                @Source,
                @BeatCount,
                @FirstBeatNumber,
                @NonIgnoredCount,
                @FirstNonIgnoredBeat,
                @ISOOffset,
                @STOffset,
                @IPoint,
                @JPoint,
                @STClass,
                @SinglesBin,
                @EditBin,
                @SubclassNumber,
                NULL
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteBinInfo';

