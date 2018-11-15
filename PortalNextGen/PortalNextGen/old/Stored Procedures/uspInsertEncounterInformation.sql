CREATE PROCEDURE [old].[uspInsertEncounterInformation]
    (
        @EncounterID          INT,
        @OrganizationID       INT           = NULL,
        @ModifiedDateTime     DATETIME2(7)  = NULL,
        @PatientID            INT           = NULL,
        @OriginalPatientID    INT           = NULL,
        @AccountID            INT           = NULL,
        @StatusCode           NVARCHAR(3)   = NULL,
        @PublicityCodeID      INT           = NULL,
        @DietTypeCodeID       INT           = NULL,
        @PatientClassCodeID   INT           = NULL,
        @protectionTypeCodeID INT           = NULL,
        @VipSwitch            BIT,
        @IsolationTypeCodeID  INT           = NULL,
        @SecurityTypeCodeID   INT           = NULL,
        @PatientTypeCodeID    INT           = NULL,
        @AdmitHcpID           INT           = NULL,
        @MedSvcCodeID         INT           = NULL,
        @ReferringHcpID       INT           = NULL,
        @UnitOrganizationID   INT           = NULL,
        @AttendHcpID          INT           = NULL,
        @PrimaryCareHcpID     INT           = NULL,
        @FallRiskTypeCodeID   INT           = NULL,
        @BeginDateTime        DATETIME2(7)  = NULL,
        @AmbulStatusCodeID    INT           = NULL,
        @AdmitDateTime        DATETIME2(7)  = NULL,
        @BabyCode             NCHAR(1)      = NULL,
        @Room                 NVARCHAR(12)  = NULL,
        @RecurringCode        NCHAR(1)      = NULL,
        @Bed                  NVARCHAR(12)  = NULL,
        @DischargeDateTime    DATETIME2(7)  = NULL,
        @NewbornSwitch        NCHAR(1)      = NULL,
        @DischargeDispoCodeID INT           = NULL,
        @MonitorCreated       TINYINT       = NULL,
        @Comment              NVARCHAR(200) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[Encounter]
            (
                [EncounterID],
                [OrganizationID],
                [ModifiedDateTime],
                [PatientID],
                [OriginalPatientID],
                [AccountID],
                [StatusCode],
                [PublicityCodeID],
                [DietTypeCodeID],
                [PatientClassCodeID],
                [ProtectionTypeCodeID],
                [VipSwitch],
                [IsolationTypeCodeID],
                [SecurityTypeCodeID],
                [PatientTypeCodeID],
                [AdmitHealthCareProviderID],
                [MedicalServiceCodeID],
                [ReferringHealthCareProviderID],
                [UnitOrganizationID],
                [AttendHealthCareProviderID],
                [PrimaryCareHealthCareProviderID],
                [FallRiskTypeCodeID],
                [BeginDateTime],
                [AmbulatoryStatusCodeID],
                [AdmitDateTime],
                [BabyCode],
                [Room],
                [RecurringCode],
                [Bed],
                [DischargeDateTime],
                [NewbornSwitch],
                [DischargeDispositionCodeID],
                [MonitorCreated],
                [Comment]
            )
        VALUES
            (
                @EncounterID, @OrganizationID, SYSUTCDATETIME(), @PatientID, @OriginalPatientID, @AccountID,
                @StatusCode, @PublicityCodeID, @DietTypeCodeID, @PatientClassCodeID, @protectionTypeCodeID, @VipSwitch,
                @IsolationTypeCodeID, @SecurityTypeCodeID, @PatientTypeCodeID, @AdmitHcpID, @MedSvcCodeID,
                @ReferringHcpID, @UnitOrganizationID, @AttendHcpID, @PrimaryCareHcpID, @FallRiskTypeCodeID,
                @BeginDateTime, @AmbulStatusCodeID, @AdmitDateTime, @BabyCode, @Room, @RecurringCode, @Bed,
                @DischargeDateTime, @NewbornSwitch, @DischargeDispoCodeID, @MonitorCreated, @Comment
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert Encounter information.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertEncounterInformation';

