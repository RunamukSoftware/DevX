CREATE PROCEDURE [dbo].[usp_HL7_UpdateEncounterMapInformation]
    (
     @EncounterId UNIQUEIDENTIFIER,
     @AccountId UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_encounter_map]
    SET
        [account_id] = @AccountId
    WHERE
        [encounter_id] = @EncounterId;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdateEncounterMapInformation';

