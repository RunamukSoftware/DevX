CREATE PROCEDURE [old].[uspWriteTemplateSetInfo]
    (
        @UserID            INT,
        @PatientID         INT,
        @TemplateSetIndex  INT,
        @LeadOne           INT,
        @LeadTwo           INT,
        @NumberOfBins      INT,
        @NumberOfTemplates INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[TemplateSetInformation]
            (
                [UserID],
                [PatientID],
                [TemplateSetIndex],
                [lead_one],
                [lead_two],
                [number_of_bins],
                [number_of_templates]
            )
        VALUES
            (
                @UserID, @PatientID, @TemplateSetIndex, @LeadOne, @LeadTwo, @NumberOfBins, @NumberOfTemplates
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteTemplateSetInfo';

