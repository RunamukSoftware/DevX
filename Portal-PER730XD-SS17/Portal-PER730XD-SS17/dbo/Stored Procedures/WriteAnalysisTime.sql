CREATE PROCEDURE [dbo].[WriteAnalysisTime]
    (
     @UserID UNIQUEIDENTIFIER,
     @PatientId UNIQUEIDENTIFIER,
     @StartFt BIGINT,
     @EndFt BIGINT,
     @AnalysisType INT
    )
AS
BEGIN
    INSERT  INTO [dbo].[AnalysisTime]
            ([user_id],
             [patient_id],
             [start_ft],
             [end_ft],
             [analysis_type]
            )
    VALUES
            (@UserID,
             @PatientId,
             @StartFt,
             @EndFt,
             @AnalysisType
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'WriteAnalysisTime';

