CREATE PROCEDURE [old].[uspPatientSummary] (@MedicalRecordNumber CHAR(30))
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @PatientID INT;

        SELECT
            @PatientID = [imm].[PatientID]
        FROM
            [Intesys].[MedicalRecordNumberMap] AS [imm]
        WHERE
            [imm].[MedicalRecordNumberXID] = @MedicalRecordNumber;

        IF (@PatientID IS NULL)
            SELECT
                'Patient not found ....';
        ELSE
            BEGIN
                SELECT
                    'PATIENT    ',
                    [ip].[PatientID],
                    [ip].[NewPatientID],
                    [ip].[OrganDonorSwitch],
                    [ip].[LivingWillSwitch],
                    [ip].[BirthOrder],
                    [ip].[VeteranStatusCodeID],
                    [ip].[BirthPlace],
                    [ip].[SocialSecurityNumber],
                    [ip].[MpiSocialSecurityNumber1],
                    [ip].[MpiSocialSecurityNumber2],
                    [ip].[MpiSocialSecurityNumber3],
                    [ip].[MpiSocialSecurityNumber4],
                    [ip].[MpiDriversLicenseNumber1],
                    [ip].[MpiDriversLicenseNumber2],
                    [ip].[MpiDriversLicenseNumber3],
                    [ip].[MpiDriversLicenseNumber4],
                    [ip].[DateOfBirth],
                    [ip].[DeathDate],
                    [ip].[NationalityCodeID],
                    [ip].[CitizenshipCodeID],
                    [ip].[EthnicGroupCodeID],
                    [ip].[RaceCodeID],
                    [ip].[GenderCodeID],
                    [ip].[PrimaryLanguageCodeID],
                    [ip].[MaritalStatusCodeID],
                    [ip].[ReligionCodeID],
                    [ip].[MonitorInterval],
                    [ip].[Height],
                    [ip].[Weight],
                    [ip].[BodySurfaceArea]
                FROM
                    [Intesys].[Patient] AS [ip]
                WHERE
                    [ip].[PatientID] = @PatientID;

                SELECT
                    'PATIENT_MON' AS [PATIENT_MON],
                    [ipm].[PatientMonitorID],
                    [ipm].[PatientID],
                    [ipm].[OriginalPatientID],
                    [ipm].[MonitorID],
                    [ipm].[MonitorInterval],
                    [ipm].[PollingType],
                    [ipm].[MonitorConnectDateTime],
                    [ipm].[MonitorConnectNumber],
                    [ipm].[DisableSwitch],
                    [ipm].[LastPollingDateTime],
                    [ipm].[LastResultDateTime],
                    [ipm].[LastEpisodicDateTime],
                    [ipm].[PollStartDateTime],
                    [ipm].[PollEndDateTime],
                    [ipm].[LastOutboundDateTime],
                    [ipm].[MonitorStatus],
                    [ipm].[MonitorError],
                    [ipm].[EncounterID],
                    [ipm].[LiveUntilDateTime],
                    [ipm].[ActiveSwitch]
                FROM
                    [Intesys].[PatientMonitor] AS [ipm]
                WHERE
                    [ipm].[PatientID] = @PatientID;

                SELECT
                    'PERSON_NAME' AS [PERSON_NAME],
                    [ipn].[PersonNameID],
                    [ipn].[RecognizeNameCode],
                    [ipn].[SequenceNumber],
                    [ipn].[OriginalPatientID],
                    [ipn].[ActiveSwitch],
                    [ipn].[Prefix],
                    [ipn].[FirstName],
                    [ipn].[MiddleName],
                    [ipn].[LastName],
                    [ipn].[Suffix],
                    [ipn].[Degree],
                    [ipn].[mpi_lname_cons],
                    [ipn].[mpi_fname_cons],
                    [ipn].[mpi_mname_cons],
                    [ipn].[StartDateTime]
                FROM
                    [Intesys].[PersonName] AS [ipn]
                WHERE
                    [ipn].[PersonNameID] = @PatientID;

                SELECT
                    'PERSON     ' AS [PERSON],
                    [ip].[PersonID],
                    [ip].[NewPatientID],
                    [ip].[FirstName],
                    [ip].[MiddleName],
                    [ip].[LastName],
                    [ip].[Suffix],
                    [ip].[TelephoneNumber],
                    [ip].[Line1Description],
                    [ip].[Line2Description],
                    [ip].[Line3Description],
                    [ip].[City],
                    [ip].[StateCode],
                    [ip].[ZipCode],
                    [ip].[CountryCodeID]
                FROM
                    [Intesys].[Person] AS [ip]
                WHERE
                    [ip].[PersonID] = @PatientID;

                SELECT
                    'MedicalRecordNumberMAP    ' AS [MedicalRecordNumberMAP],
                    [imm].[OrganizationID],
                    [imm].[MedicalRecordNumberXID],
                    [imm].[PatientID],
                    [imm].[OriginalPatientID],
                    [imm].[MergeCode],
                    [imm].[PriorPatientID],
                    [imm].[MedicalRecordNumberXID2],
                    [imm].[AdmitDischargeTransferAdmitSwitch]
                FROM
                    [Intesys].[MedicalRecordNumberMap] AS [imm]
                WHERE
                    [imm].[PatientID] = @PatientID;

                SELECT
                    'ENCOUNTER  ' AS [ENCOUNTER],
                    [ie].[EncounterID],
                    [ie].[OrganizationID],
                    [ie].[ModifiedDateTime],
                    [ie].[PatientID],
                    [ie].[OriginalPatientID],
                    [ie].[AccountID],
                    [ie].[StatusCode],
                    [ie].[PublicityCodeID],
                    [ie].[DietTypeCodeID],
                    [ie].[PatientClassCodeID],
                    [ie].[ProtectionTypeCodeID],
                    [ie].[VipSwitch],
                    [ie].[IsolationTypeCodeID],
                    [ie].[SecurityTypeCodeID],
                    [ie].[PatientTypeCodeID],
                    [ie].[AdmitHealthCareProviderID],
                    [ie].[MedicalServiceCodeID],
                    [ie].[ReferringHealthCareProviderID],
                    [ie].[UnitOrganizationID],
                    [ie].[AttendHealthCareProviderID],
                    [ie].[PrimaryCareHealthCareProviderID],
                    [ie].[FallRiskTypeCodeID],
                    [ie].[BeginDateTime],
                    [ie].[AmbulatoryStatusCodeID],
                    [ie].[AdmitDateTime],
                    [ie].[BabyCode],
                    [ie].[Room],
                    [ie].[RecurringCode],
                    [ie].[Bed],
                    [ie].[DischargeDateTime],
                    [ie].[NewbornSwitch],
                    [ie].[DischargeDispositionCodeID],
                    [ie].[MonitorCreated],
                    [ie].[Comment]
                FROM
                    [Intesys].[Encounter] AS [ie]
                WHERE
                    [ie].[PatientID] = @PatientID;

                SELECT
                    'ORDER_MAP  ' AS [ORDER_MAP],
                    [iom].[OrderID],
                    [iom].[PatientID],
                    [iom].[OriginalPatientID],
                    [iom].[OrganizationID],
                    [iom].[SystemID],
                    [iom].[OrderXID],
                    [iom].[TypeCode],
                    [iom].[SequenceNumber]
                FROM
                    [Intesys].[OrderMap] AS [iom]
                WHERE
                    [iom].[PatientID] = @PatientID;

                SELECT
                    'ORDER      ' AS [ORDER],
                    [io].[EncounterID],
                    [io].[OrderID],
                    [io].[PatientID],
                    [io].[OriginalPatientID],
                    [io].[PriorityCodeID],
                    [io].[StatusCodeID],
                    [io].[OrderPersonID],
                    [io].[OrderDateTime],
                    [io].[EnterID],
                    [io].[VerificationID],
                    [io].[TranscriberID],
                    [io].[ParentOrderID],
                    [io].[ChildOrderSwitch],
                    [io].[OrderControlCodeID],
                    [io].[HistorySwitch],
                    [io].[MonitorSwitch]
                FROM
                    [Intesys].[Order] AS [io]
                WHERE
                    [io].[PatientID] = @PatientID;

                SELECT
                    'ORDER_LINE ' AS [ORDER_LINE],
                    [iol].[OrderID],
                    [iol].[SequenceNumber],
                    [iol].[PatientID],
                    [iol].[OriginalPatientID],
                    [iol].[StatusCodeID],
                    [iol].[TransportCodeID],
                    [iol].[OrderLineComment],
                    [iol].[clin_info_comment],
                    [iol].[ReasonComment],
                    [iol].[scheduledDateTime],
                    [iol].[status_chgDateTime]
                FROM
                    [Intesys].[OrderLine] AS [iol]
                WHERE
                    [iol].[PatientID] = @PatientID;

                SELECT
                    'RESULT     ' AS [RESULT],
                    [ir].[ResultID],
                    [ir].[PatientID],
                    [ir].[OriginalPatientID],
                    [ir].[ObservationStartDateTime],
                    [ir].[OrderID],
                    [ir].[IsHistory],
                    [ir].[MonitorSwitch],
                    [ir].[TestCodeID],
                    [ir].[HistorySequence],
                    [ir].[test_subID],
                    [ir].[OrderLineSequenceNumber],
                    [ir].[TestResultSequenceNumber],
                    [ir].[ResultDateTime],
                    [ir].[ValueTypeCode],
                    [ir].[SpecimenID],
                    [ir].[SourceCodeID],
                    [ir].[StatusCodeID],
                    [ir].[LastNormalDateTime],
                    [ir].[Probability],
                    [ir].[ObservationID],
                    [ir].[PrincipalResultInterpretationID],
                    [ir].[AssistantResultInterpretationID],
                    [ir].[TechnicianID],
                    [ir].[TranscriberID],
                    [ir].[ResultUnitsCodeID],
                    [ir].[ReferenceRangeID],
                    [ir].[AbnormalCode],
                    [ir].[AbnormalNatureCode],
                    [ir].[ResultValue],
                    [ir].[ResultText],
                    [ir].[ResultComment],
                    [ir].[HasHistory],
                    [ir].[ModifiedDateTime],
                    [ir].[ModifiedUserID],
                    [ir].[ResultID],
                    [ir].[ResultDateTime]
                FROM
                    [Intesys].[Result] AS [ir]
                WHERE
                    [ir].[PatientID] = @PatientID;
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspPatientSummary';

