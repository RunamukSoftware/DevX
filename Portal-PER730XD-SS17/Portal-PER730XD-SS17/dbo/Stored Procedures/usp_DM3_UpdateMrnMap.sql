 CREATE PROCEDURE [dbo].[usp_DM3_UpdateMrnMap]
    (
     @PatientGUID NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @MainOrgID NVARCHAR(50) = NULL -- TG - should be UNIQUEIDENTIFIER
    )
 AS
 BEGIN
    UPDATE
        [dbo].[int_mrn_map]
    SET
        [adt_adm_sw] = NULL
    WHERE
        [patient_id] = CAST(@PatientGUID AS UNIQUEIDENTIFIER)
        AND [organization_id] = CAST(@MainOrgID AS UNIQUEIDENTIFIER);
 END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_UpdateMrnMap';

