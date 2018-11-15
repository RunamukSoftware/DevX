CREATE PROCEDURE [dbo].[usp_InsertEncounterMapInformation]
    (
     @EncounterXid NVARCHAR(80), -- TG - Should be NVARCHAR(40)
     @OrgId UNIQUEIDENTIFIER,
     @EncounterId UNIQUEIDENTIFIER,
     @PatientId UNIQUEIDENTIFIER,
     @SeqNo INT,
     @OrgPatientId UNIQUEIDENTIFIER = NULL,
     @StatusCd NCHAR(2) = NULL, -- TG - Should be NCHAR(1)
     @EventCd NVARCHAR(8) = NULL, -- TG - Should be NVARCHAR(4)
     @AccountId UNIQUEIDENTIFIER = NULL
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_encounter_map]
            ([encounter_xid],
             [organization_id],
             [encounter_id],
             [patient_id],
             [seq_no],
             [orig_patient_id],
             [status_cd],
             [event_cd],
             [account_id]
            )
    VALUES
            (CAST(@EncounterXid AS NVARCHAR(40)),
             @OrgId,
             @EncounterId,
             @PatientId,
             @SeqNo,
             @OrgPatientId,
             CAST(@StatusCd AS NCHAR(1)),
             CAST(@EventCd AS NVARCHAR(4)),
             @AccountId
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert Encounter map information.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertEncounterMapInformation';

