CREATE PROCEDURE [old].[uspGetPatientSavedEventVitals]
    (
        @PatientID   INT,
        @EventID AS  INT,
        @GlobalDataSystemCode AS NVARCHAR(80)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isv].[ResultDateTime],
            [isv].[ResultValue]
        FROM
            [Intesys].[SavedEventVital] AS [isv]
        WHERE
            [isv].[PatientID] = @PatientID
            AND [isv].[EventID] = @EventID
            AND [isv].[GlobalDataSystemCode] = @GlobalDataSystemCode;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEventVitals';

