CREATE PROCEDURE [dbo].[usp_IsVIPPatient] (@mrn_xid NVARCHAR(30))
AS
BEGIN
    SELECT
        [ENC].[vip_sw]
    FROM
        [dbo].[int_encounter] AS [ENC]
        INNER JOIN [dbo].[int_mrn_map] AS [MRNMAP] ON [MRNMAP].[patient_id] = [ENC].[patient_id]
    WHERE
        [MRNMAP].[mrn_xid] = @mrn_xid;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_IsVIPPatient';

