CREATE PROCEDURE [Purger].[uspDeleteAllPatientData]
AS
    BEGIN
        SET NOCOUNT ON;

        TRUNCATE TABLE [HL7].[InputQueueHistory];

        TRUNCATE TABLE [HL7].[InputQueue];

        TRUNCATE TABLE [HL7].[MessageAcknowledgement];

        TRUNCATE TABLE [HL7].[OutputQueue];

        TRUNCATE TABLE [Intesys].[TwelveLeadReportNew];

        TRUNCATE TABLE [Intesys].[TwelveLeadReportEdit];

        TRUNCATE TABLE [Intesys].[Account];

        TRUNCATE TABLE [Intesys].[Address];

        TRUNCATE TABLE [Intesys].[Alarm];

        TRUNCATE TABLE [Intesys].[AlarmRetrieved];

        TRUNCATE TABLE [Intesys].[AlarmWaveform];

        --TRUNCATE TABLE [Intesys].[allergy];

        TRUNCATE TABLE [Intesys].[Diagnosis];

        TRUNCATE TABLE [Intesys].[DiagnosisRelatedGroup];

        TRUNCATE TABLE [Intesys].[DiagnosisHealthCareProviderInt];

        TRUNCATE TABLE [Intesys].[Encounter];

        TRUNCATE TABLE [Intesys].[EncounterMap];

        TRUNCATE TABLE [Intesys].[EncounterTransferHistory];

        TRUNCATE TABLE [Intesys].[EncounterToDiagnosisHealthCareProviderInt];

        TRUNCATE TABLE [Intesys].[EventLog];

        TRUNCATE TABLE [Intesys].[ExternalOrganization];

        TRUNCATE TABLE [Archive].[Guarantor];

        TRUNCATE TABLE [Intesys].[HealthCareProvider];

        TRUNCATE TABLE [Intesys].[HealthCareProviderContact];

        TRUNCATE TABLE [Intesys].[HealthCareProviderLicense];

        TRUNCATE TABLE [Intesys].[HealthCareProviderMap];

        TRUNCATE TABLE [Intesys].[HealthCareProviderSpecialty];

        TRUNCATE TABLE [Archive].[InsurancePlan];

        TRUNCATE TABLE [Archive].[InsurancePolicy];

        TRUNCATE TABLE [Intesys].[MedicalRecordNumberMap];

        TRUNCATE TABLE [Intesys].[NextOfKin];

        TRUNCATE TABLE [Intesys].[Order];

        TRUNCATE TABLE [Intesys].[OrderLine];

        TRUNCATE TABLE [Intesys].[OrderMap];

        TRUNCATE TABLE [Intesys].[OutboundQueue];

        TRUNCATE TABLE [Intesys].[ParameterTimeTag];

        TRUNCATE TABLE [Intesys].[Patient];

        TRUNCATE TABLE [Intesys].[PatientChannel];

        --TRUNCATE TABLE [Intesys].[patient_document];

        --TRUNCATE TABLE [Intesys].[patient_image];

        TRUNCATE TABLE [Intesys].[PatientLink];

        TRUNCATE TABLE [Intesys].[PatientList];

        TRUNCATE TABLE [Intesys].[PatientListDetail];

        TRUNCATE TABLE [Intesys].[PatientListLink];

        TRUNCATE TABLE [Intesys].[PatientMonitor];

        TRUNCATE TABLE [Intesys].[PatientProcedure];

        TRUNCATE TABLE [Intesys].[Person];

        TRUNCATE TABLE [Intesys].[PersonName];

        TRUNCATE TABLE [Intesys].[PrintJob];

        TRUNCATE TABLE [Intesys].[PrintJobWaveform];

        TRUNCATE TABLE [Intesys].[Procedure];

        TRUNCATE TABLE [Intesys].[ProcedureHealthCareProvider];

        TRUNCATE TABLE [Intesys].[ReferenceRange];

        TRUNCATE TABLE [Intesys].[Result];

        --TRUNCATE TABLE [Intesys].[specimen];

        --TRUNCATE TABLE [Intesys].[specimen_group];

        TRUNCATE TABLE [Intesys].[Telephone];

        --TRUNCATE TABLE [Intesys].[tech_map];

        TRUNCATE TABLE [Intesys].[VitalLive];

        TRUNCATE TABLE [Intesys].[Waveform];

        TRUNCATE TABLE [Intesys].[WaveformLive];

        TRUNCATE TABLE [Archive].[MasterPatientIndexDecisionLog];

        TRUNCATE TABLE [Archive].[MasterPatientIndexDecisionField];

        TRUNCATE TABLE [Archive].[MasterPatientIndexDecisionQueue];

        TRUNCATE TABLE [Archive].[MasterPatientIndexPatientLink];

        TRUNCATE TABLE [Archive].[MasterPatientIndexSearchResults];

        TRUNCATE TABLE [Archive].[MasterPatientIndexSearchWork];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspDeleteAllPatientData';

