CREATE PROCEDURE [HL7].[uspUpdateEncounterInformation]
    (
        @EncounterID          INT,
        @ModifiedDateTime     DATETIME2(7) = NULL,
        @AccountID            INT,
        @StatusCode           NVARCHAR(3),
        @PatientClassCodeID   INT,
        @VipSwitch            BIT,
        @PatientTypeCodeID    INT,
        @MedSvcCodeID         INT,
        @UnitOrganizationID   INT,
        @BeginDateTime        DATETIME2(7),
        @AmbulStatusCodeID    INT,
        @AdmitDateTime        DATETIME2(7),
        @Room                 NVARCHAR(12),
        @Bed                  NVARCHAR(12),
        @DischargeDateTime    DATETIME2(7),
        @DischargeDispoCodeID INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@ModifiedDateTime IS NULL)
            SET @ModifiedDateTime = SYSUTCDATETIME();

        UPDATE
            [Intesys].[Encounter]
        SET
            [AccountID] = @AccountID,
            [ModifiedDateTime] = @ModifiedDateTime,
            [StatusCode] = @StatusCode,
            [PatientClassCodeID] = @PatientClassCodeID,
            [VipSwitch] = @VipSwitch,
            [PatientTypeCodeID] = @PatientTypeCodeID,
            [MedicalServiceCodeID] = @MedSvcCodeID,
            [UnitOrganizationID] = @UnitOrganizationID,
            [BeginDateTime] = @BeginDateTime,
            [AmbulatoryStatusCodeID] = @AmbulStatusCodeID,
            [AdmitDateTime] = @AdmitDateTime,
            [Room] = @Room,
            [Bed] = @Bed,
            [DischargeDateTime] = @DischargeDateTime,
            [DischargeDispositionCodeID] = @DischargeDispoCodeID
        WHERE
            [EncounterID] = @EncounterID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateEncounterInformation';

