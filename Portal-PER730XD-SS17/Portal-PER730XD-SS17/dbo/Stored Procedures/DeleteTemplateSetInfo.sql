CREATE PROCEDURE [dbo].[DeleteTemplateSetInfo]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @TemplateSetIndex INT
    )
AS
BEGIN
    DELETE FROM
        [dbo].[int_template_set_info]
    WHERE
        [user_id] = CAST(@UserID AS UNIQUEIDENTIFIER)
        AND [patient_id] = CAST(@PatientId AS UNIQUEIDENTIFIER)
        AND [template_set_index] = @TemplateSetIndex;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'DeleteTemplateSetInfo';

