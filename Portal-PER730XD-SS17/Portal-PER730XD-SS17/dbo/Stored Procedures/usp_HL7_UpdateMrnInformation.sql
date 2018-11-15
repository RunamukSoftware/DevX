CREATE PROCEDURE [dbo].[usp_HL7_UpdateMrnInformation]
    (
     @mrn1 NVARCHAR(60), -- TG - Should be NVARCHAR(30)
     @PatientId UNIQUEIDENTIFIER,
     @mrn2 NVARCHAR(60) -- TG - Should be NVARCHAR(30)
    )
AS
BEGIN
    UPDATE
        [dbo].[int_mrn_map]
    SET
        [mrn_xid] = CAST(@mrn1 AS NVARCHAR(30)),
        [mrn_xid2] = CAST(@mrn2 AS NVARCHAR(30))
    WHERE
        [patient_id] = @PatientId
        AND [merge_cd] <> 'L';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_UpdateMrnInformation';

