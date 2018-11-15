CREATE PROCEDURE [dbo].[p_Duplicated_Patient_List]
AS
BEGIN
    SELECT
        [DUP].[duplicate_rec_id],
        [DUP].[Duplicate_Id] AS [MRN],
        [imm].[patient_id]
    INTO
        [#TMP1]
    FROM
        [dbo].[ml_duplicate_info] AS [DUP]
        INNER JOIN [dbo].[int_mrn_map] AS [imm] ON [DUP].[Duplicate_Id] = [imm].[mrn_xid]
        INNER JOIN [dbo].[int_patient_monitor] AS [mon] ON [imm].[patient_id] = [mon].[patient_id]
    WHERE
        [mon].[active_sw] = 1;

    SELECT
        [DUP].[duplicate_rec_id],
        [DUP].[Original_ID] AS [MRN],
        [imm].[patient_id]
    INTO
        [#TMP2]
    FROM
        [dbo].[ml_duplicate_info] AS [DUP]
        INNER JOIN [dbo].[int_mrn_map] AS [imm] ON [DUP].[Original_ID] = [imm].[mrn_xid]
        INNER JOIN [dbo].[int_patient_monitor] AS [mon] ON [imm].[patient_id] = [mon].[patient_id]
    WHERE
        [mon].[active_sw] = 1;

    SELECT DISTINCT
        [MAP].[patient_id] AS [PATID],
        [MAP].[mrn_xid]
    FROM
        [dbo].[int_mrn_map] AS [MAP]
        INNER JOIN [dbo].[int_patient_monitor] AS [mon] ON [MAP].[patient_id] = [mon].[patient_id]
    WHERE
        [MAP].[mrn_xid] IN (SELECT
                                [Original_ID]
                            FROM
                                [dbo].[ml_duplicate_info] AS [DUP]
                            WHERE
                                [DUP].[duplicate_rec_id] IN (SELECT
                                                                [#TMP1].[duplicate_rec_id]
                                                             FROM
                                                                [#TMP1]
                                                                INNER JOIN [#TMP2] ON [#TMP1].[duplicate_rec_id] = [#TMP2].[duplicate_rec_id]))
        OR [MAP].[mrn_xid] IN (SELECT
                                [Duplicate_Id]
                               FROM
                                [dbo].[ml_duplicate_info] AS [DUP]
                               WHERE
                                [DUP].[duplicate_rec_id] IN (SELECT
                                                                [#TMP1].[duplicate_rec_id]
                                                             FROM
                                                                [#TMP1]
                                                                INNER JOIN [#TMP2] ON [#TMP1].[duplicate_rec_id] = [#TMP2].[duplicate_rec_id]))
        AND [mon].[active_sw] = 1;

    DROP TABLE [#TMP1];

    DROP TABLE [#TMP2];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Duplicated_Patient_List';

