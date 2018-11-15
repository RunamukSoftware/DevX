CREATE PROCEDURE [old].[uspGetPatientsList]
    (
        @UnitID VARCHAR(40),
        @Status NVARCHAR(40)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @return_value TABLE
            (
                [PatientID]             INT,
                [patient_name]          NVARCHAR(100),
                [MonitorName]           NVARCHAR(30),
                [AccountID]             NVARCHAR(30),
                [MedicalRecordNumberID] NVARCHAR(30),
                [UnitID]                INT,
                [OrganizationCode]      NVARCHAR(20),
                [FacilityID]            INT,
                [FACILITY_NAME]         NVARCHAR(20),
                [DateOfBirth]           DATETIME2(7),
                [AdmitTime]             DATETIME2(7),
                [DischargedTime]        DATETIME2(7),
                [PatientMonitorID]      INT,
                [Status]                VARCHAR(40)
            );

        INSERT @return_value
        EXEC [User].[uspGetUserPatientList]
            @UnitID = @UnitID,
            @Status = @Status;

        SELECT
            [PatientID],
            [patient_name],
            [MonitorName],
            [AccountID],
            [MedicalRecordNumberID],
            [UnitID],
            [OrganizationCode],
            [FacilityID],
            [FACILITY_NAME],
            [DateOfBirth],
            [AdmitTime],
            [DischargedTime],
            [PatientMonitorID],
            [Status]
        FROM
            @return_value;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientsList';

