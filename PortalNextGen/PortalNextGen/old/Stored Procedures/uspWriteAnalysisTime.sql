CREATE PROCEDURE [old].[uspWriteAnalysisTime]
    (
        @UserID        INT,
        @PatientID     INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7),
        @AnalysisType  INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[AnalysisTime]
            (
                [UserID],
                [PatientID],
                [StartDateTime],
                [EndDateTime],
                [AnalysisType]
            )
        VALUES
            (
                @UserID, @PatientID, @StartDateTime, @EndDateTime, @AnalysisType
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteAnalysisTime';

