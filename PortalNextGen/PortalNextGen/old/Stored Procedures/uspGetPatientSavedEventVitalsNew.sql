CREATE PROCEDURE [old].[uspGetPatientSavedEventVitalsNew]
    (
        @PatientID  INT,
        @EventID AS INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isv].[ResultDateTime],
            [isv].[ResultValue],
            [isv].[GlobalDataSystemCode]
        FROM
            [Intesys].[SavedEventVital] AS [isv]
        WHERE
            [isv].[PatientID] = @PatientID
            AND [isv].[EventID] = @EventID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEventVitalsNew';

