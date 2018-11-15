CREATE PROCEDURE [old].[uspDeleteTemplateSetInfo]
    (
        @UserID           INT,
        @PatientID        INT,
        @TemplateSetIndex INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE FROM
        [Intesys].[TemplateSetInformation]
        WHERE
            [UserID] = @UserID
            AND [PatientID] = @PatientID
            AND [TemplateSetIndex] = @TemplateSetIndex;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteTemplateSetInfo';

