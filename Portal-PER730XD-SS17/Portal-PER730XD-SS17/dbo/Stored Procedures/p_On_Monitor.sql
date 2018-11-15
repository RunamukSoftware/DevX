CREATE PROCEDURE [dbo].[p_On_Monitor]
AS
BEGIN
    SELECT
        [ipm].[patient_id],
        CONVERT(CHAR(10), [imm].[mrn_xid]) AS [MRN],
        [im].[monitor_name] AS [MONITOR],
        CONVERT(CHAR(15), [ipn].[last_nm]) AS [LAST NAME],
        CONVERT(CHAR(15), [ipn].[first_nm]) AS [FIRST NAME],
        [ipm].[monitor_interval] AS [INTERVAL],
        [ipm].[poll_start_dt],
        [ipm].[poll_end_dt],
        [ipm].[monitor_status],
        [ipm].[monitor_error]
    FROM
        [dbo].[int_mrn_map] AS [imm]
        INNER JOIN [dbo].[int_person_name] AS [ipn] ON [imm].[patient_id] = [ipn].[person_nm_id]
        INNER JOIN [dbo].[int_patient_monitor] AS [ipm] ON [ipm].[patient_id] = [imm].[patient_id]
        INNER JOIN [dbo].[int_monitor] AS [im] ON [ipm].[monitor_id] = [im].[monitor_id];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_On_Monitor';

