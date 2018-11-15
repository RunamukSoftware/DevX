CREATE PROCEDURE [dbo].[RetrieveBinInfo]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @TemplateSetIndex INT
    )
AS
BEGIN
    SELECT
        [ibi].[user_id],
        [ibi].[patient_id],
        [ibi].[template_set_index],
        [ibi].[template_index],
        [ibi].[bin_number],
        [ibi].[source],
        [ibi].[beat_count],
        [ibi].[first_beat_number],
        [ibi].[non_ignored_count],
        [ibi].[first_non_ignored_beat],
        [ibi].[iso_offset],
        [ibi].[st_offset],
        [ibi].[i_point],
        [ibi].[j_point],
        [ibi].[st_class],
        [ibi].[singles_bin],
        [ibi].[edit_bin],
        [ibi].[subclass_number],
        [ibi].[bin_image]
    FROM
        [dbo].[int_bin_info] AS [ibi]
    WHERE
        [ibi].[user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [ibi].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [ibi].[template_set_index] = @TemplateSetIndex;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'RetrieveBinInfo';

