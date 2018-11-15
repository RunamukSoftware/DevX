CREATE PROCEDURE [HL7].[uspUpdatePatientVisitInformation]
    (
        @EncounterID        INT,
        @ModifiedDateTime   DATETIME2(7) = NULL,
        @AccountID          INT          = NULL,
        @StatusCode         NVARCHAR(3),
        @PatientClassCodeID INT          = NULL,
        @VipSwitch          BIT          = NULL,
        @PatientTypeCodeID  INT          = NULL,
        @UnitOrganizationID INT,
        @AdmitDateTime      DATETIME2(7) = NULL,
        @Room               NVARCHAR(80) = NULL,
        @Bed                NVARCHAR(80) = NULL,
        @DischargeDateTime  DATETIME2(7) = NULL,
        @MessageDateTime    DATETIME2(7) = NULL
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
            [VipSwitch] = @VipSwitch,
            [PatientTypeCodeID] = @PatientTypeCodeID,
            [PatientClassCodeID] = @PatientClassCodeID,
            [UnitOrganizationID] = @UnitOrganizationID,
            [AdmitDateTime] = @AdmitDateTime,
            [Room] = @Room,
            [Bed] = @Bed,
            [BeginDateTime] = @MessageDateTime,
            [DischargeDateTime] = @DischargeDateTime
        WHERE
            [EncounterID] = @EncounterID;

        UPDATE
            [Intesys].[EncounterMap]
        SET
            [AccountID] = @AccountID
        WHERE
            [EncounterID] = @EncounterID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the patients Visit Information.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdatePatientVisitInformation';

