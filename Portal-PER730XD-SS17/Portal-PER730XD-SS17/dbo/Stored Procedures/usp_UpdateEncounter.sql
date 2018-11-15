CREATE PROCEDURE [dbo].[usp_UpdateEncounter]
    (
     @unit_org_id UNIQUEIDENTIFIER,
     @organization_id UNIQUEIDENTIFIER,
     @rm NVARCHAR(6),
     @bed NVARCHAR(6),
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_encounter]
    SET
        [unit_org_id] = @unit_org_id,
        [organization_id] = @organization_id,
        [rm] = @rm,
        [bed] = @bed
    WHERE
        [status_cd] = N'C'
        AND [patient_id] = @patient_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateEncounter';

