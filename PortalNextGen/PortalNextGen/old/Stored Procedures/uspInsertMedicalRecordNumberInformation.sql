CREATE PROCEDURE [old].[uspInsertMedicalRecordNumberInformation]
    (
        @OrganizationID       INT,
        @MedicalRecordNumber1 NVARCHAR(30),
        @PatientID            INT,
        @orgPatientID         INT          = NULL,
        @priorPatientID       INT          = NULL,
        @MedicalRecordNumber2 NVARCHAR(30) = NULL,
        @AdtAdmitSwitch       BIT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[MedicalRecordNumberMap]
            (
                [OrganizationID],
                [MedicalRecordNumberXID],
                [PatientID],
                [OriginalPatientID],
                [MergeCode],
                [PriorPatientID],
                [MedicalRecordNumberXID2],
                [AdmitDischargeTransferAdmitSwitch]
            )
        VALUES
            (
                @OrganizationID, @MedicalRecordNumber1, @PatientID, @orgPatientID, 'C', @priorPatientID,
                @MedicalRecordNumber2, @AdtAdmitSwitch
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert the patient MedicalRecordNumber Information from any component @OrganizationID, @MedicalRecordNumber1 is mandatory and the remaining are optional with default NULL values', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertMedicalRecordNumberInformation';

