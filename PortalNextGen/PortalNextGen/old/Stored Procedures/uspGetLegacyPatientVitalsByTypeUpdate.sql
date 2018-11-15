CREATE PROCEDURE [old].[uspGetLegacyPatientVitalsByTypeUpdate]
    (
        @PatientID           INT,
        @Type                INT,
        @SequenceNumberAfter INT,
        @DateAfter           DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ir].[ResultValue],
            [ir].[ObservationStartDateTime],
            [ir].[ResultID],
            [ir].[ResultDateTime],
            CAST(1 AS BIT) AS [IsResultLocalized]
        FROM
            [Intesys].[Result]                AS [ir]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [CODE]
                    ON [ir].[TestCodeID] = [CODE].[CodeID]
        WHERE
            [ir].[PatientID] = @PatientID
            AND [CODE].[CodeID] = @Type
            AND [ir].[ResultID] > @SequenceNumberAfter
        ORDER BY
            [ir].[ResultDateTime] ASC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dummy view creation for Enhanced Telemetry (ET) - Temp fix for resolving dependencies for smooth installation of the build. --Remove / Replace this with actual view when it becomes available. --Get vitals data for trends view in CA', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientVitalsByTypeUpdate';

