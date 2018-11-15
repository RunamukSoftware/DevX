CREATE PROCEDURE [dbo].[WriteTrendData]
    (
     @UserID [dbo].[DUSER_ID], -- TG - Should be UNIQUEIDENTIFIER
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @TotalCategories INT,
     @StartFT BIGINT,
     @TotalPeriods INT,
     @SamplesPerPeriod FLOAT, -- TG - Should be INT
     @TrendData IMAGE
    )
AS
BEGIN
    INSERT  INTO [dbo].[TrendData]
            ([user_id],
             [patient_id],
             [total_categories],
             [start_ft],
             [total_periods],
             [samples_per_period],
             [trend_data]
            )
    VALUES
            (CAST(@UserID AS UNIQUEIDENTIFIER),
             CAST(@PatientId AS UNIQUEIDENTIFIER),
             @TotalCategories,
             @StartFT,
             @TotalPeriods,
             CAST(@SamplesPerPeriod AS INT),
             @TrendData
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'WriteTrendData';

