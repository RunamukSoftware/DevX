CREATE PROCEDURE [DM3].[uspUpdateMedicalRecordNumberMap]
    (
        @PatientID          INT,
        @MainOrganizationID INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[MedicalRecordNumberMap]
        SET
            [AdmitDischargeTransferAdmitSwitch] = NULL
        WHERE
            [PatientID] = @PatientID
            AND [OrganizationID] = @MainOrganizationID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspUpdateMedicalRecordNumberMap';

