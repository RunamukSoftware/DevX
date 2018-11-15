CREATE PROCEDURE [old].[uspSaveEndPatientSession] (@EndPatientSessionData [old].[utpPatientSession] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [old].[PatientSession]
        SET
            [EndDateTime] = [x].[EndDateTime]
        FROM
            @EndPatientSessionData AS [x]
        WHERE
            [PatientSession].[PatientSessionID] = [x].[PatientSessionID]
            AND [PatientSession].[EndDateTime] IS NULL;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEndPatientSession';

