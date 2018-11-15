CREATE PROCEDURE [old].[uspDeleteBinInfo]
    (
        @UserID           INT,
        @PatientID        INT,
        @TemplateSetIndex INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DELETE
        [ibi]
        FROM
            [Intesys].[BinInformation] AS [ibi]
        WHERE
            [ibi].[UserID] = @UserID
            AND [ibi].[PatientID] = @PatientID
            AND [ibi].[TemplateSetIndex] = @TemplateSetIndex;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspDeleteBinInfo';

