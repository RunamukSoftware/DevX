CREATE PROCEDURE [old].[uspGetLegacyPatientVitalsTimeHistory] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [ir].[ResultDateTime],
            [ir].[ResultDateTime]
        FROM
            [Intesys].[Result] AS [ir]
        WHERE
            [ir].[PatientID] = @PatientID
        ORDER BY
            [ir].[ResultDateTime] ASC;
    END;