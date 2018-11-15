CREATE PROCEDURE [old].[uspRetrieveBinInfo]
    (
        @UserID           INT,
        @PatientID        INT,
        @TemplateSetIndex INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ibi].[UserID],
            [ibi].[PatientID],
            [ibi].[TemplateSetIndex],
            [ibi].[TemplateIndex],
            [ibi].[BinNumber],
            [ibi].[Source],
            [ibi].[BeatCount],
            [ibi].[FirstBeatNumber],
            [ibi].[NonIgnoredCount],
            [ibi].[FirstNonIgnoredBeat],
            [ibi].[iso_offset],
            [ibi].[st_offset],
            [ibi].[i_point],
            [ibi].[j_point],
            [ibi].[st_class],
            [ibi].[SinglesBin],
            [ibi].[EditBin],
            [ibi].[SubclassNumber],
            [ibi].[BinImage]
        FROM
            [Intesys].[BinInformation] AS [ibi]
        WHERE
            [ibi].[UserID] = @UserID
            AND [ibi].[PatientID] = @PatientID
            AND [ibi].[TemplateSetIndex] = @TemplateSetIndex;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrieveBinInfo';

