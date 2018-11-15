CREATE PROCEDURE [dbo].[DeleteBinInfo]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @TemplateSetIndex INT
    )
AS
BEGIN
    DELETE
        [ibi]
    FROM
        [dbo].[int_bin_info] AS [ibi]
    WHERE
        [ibi].[user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [ibi].[patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [ibi].[template_set_index] = @TemplateSetIndex;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteBinInfo';

