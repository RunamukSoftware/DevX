CREATE PROCEDURE [old].[uspRetrieveTemplateSetInfo]
    (
        @UserID           INT,
        @PatientID        INT,
        @TemplateSetIndex INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [tsi].[UserID],
            [tsi].[PatientID],
            [tsi].[TemplateSetIndex],
            [tsi].[lead_one],
            [tsi].[lead_two],
            [tsi].[number_of_bins],
            [tsi].[number_of_templates]
        FROM
            [Intesys].[TemplateSetInformation] AS [tsi]
        WHERE
            [tsi].[UserID] = @UserID
            AND [tsi].[PatientID] = @PatientID
            AND [tsi].[TemplateSetIndex] = @TemplateSetIndex;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspRetrieveTemplateSetInfo';

