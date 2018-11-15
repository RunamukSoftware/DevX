CREATE PROCEDURE [old].[uspWriteTrendData]
    (
        @UserID           INT,
        @PatientID        INT,
        @TotalCategories  INT,
        @StartDateTime    INT,
        @TotalPeriods     INT,
        @SamplesPerPeriod INT,
        @TrendData        VARBINARY(MAX)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[Trend]
            (
                [UserID],
                [PatientID],
                [TotalCategories],
                [StartDateTime],
                [TotalPeriods],
                [SamplesPerPeriod],
                [TrendData]
            )
        VALUES
            (
                @UserID,
                @PatientID,
                @TotalCategories,
                @StartDateTime,
                @TotalPeriods,
                @SamplesPerPeriod,
                @TrendData
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspWriteTrendData';

