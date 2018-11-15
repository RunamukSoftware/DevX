CREATE PROCEDURE [dbo].[usp_UpdateMrn]
    (
     @mrn_xid NVARCHAR(30),
     @mrn_xid2 NVARCHAR(30),
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_mrn_map]
    SET
        [mrn_xid] = @mrn_xid,
        [mrn_xid2] = @mrn_xid2
    WHERE
        [patient_id] = @patient_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdateMrn';

