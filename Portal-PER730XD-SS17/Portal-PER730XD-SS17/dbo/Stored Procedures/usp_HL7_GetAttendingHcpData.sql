CREATE PROCEDURE [dbo].[usp_HL7_GetAttendingHcpData]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [hcpMap].[hcp_xid] AS [hcpID],
        [last_nm] AS [hcpLastName],
        [first_nm] AS [hcpFirstName],
        [middle_nm] AS [hcpMiddleName]
    FROM
        [dbo].[int_hcp] AS [hcp]
        INNER JOIN [dbo].[int_hcp_map] AS [hcpMap] ON [hcp].[hcp_id] = [hcpMap].[hcp_id]
        INNER JOIN [dbo].[int_encounter] AS [enc] ON [enc].[attend_hcp_id] = [hcp].[hcp_id]
        INNER JOIN [dbo].[int_encounter_map] AS [encMap] ON [enc].[encounter_id] = [encMap].[encounter_id]
    WHERE
        [enc].[patient_id] = @patient_id
        AND [encMap].[seq_no] = 1
        AND [encMap].[status_cd] = N'C';
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get attending HCP data.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetAttendingHcpData';

