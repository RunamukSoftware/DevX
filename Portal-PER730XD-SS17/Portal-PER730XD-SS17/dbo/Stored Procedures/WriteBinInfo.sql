CREATE PROCEDURE [dbo].[WriteBinInfo]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @TemplateSetIndex INT,
     @TemplateIndex INT,
     @BinNumber INT,
     @Source INT,
     @BeatCount INT,
     @FirstBeatNumber INT,
     @NonIgnoredCount INT,
     @FirstNonIgnoredBeat INT,
     @ISOOffset INT,
     @STOffset INT,
     @IPoint INT,
     @JPoint INT,
     @STClass INT,
     @SinglesBin INT,
     @EditBin INT,
     @SubclassNumber INT
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_bin_info]
            ([user_id],
             [patient_id],
             [template_set_index],
             [template_index],
             [bin_number],
             [source],
             [beat_count],
             [first_beat_number],
             [non_ignored_count],
             [first_non_ignored_beat],
             [iso_offset],
             [st_offset],
             [i_point],
             [j_point],
             [st_class],
             [singles_bin],
             [edit_bin],
             [subclass_number],
             [bin_image]
            )
    VALUES
            (CAST(@UserID AS UNIQUEIDENTIFIER),
             CAST(@PatientId AS UNIQUEIDENTIFIER),
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'WriteBinInfo';

