CREATE TABLE [dbo].[int_mrn_map] (
    [organization_id]  UNIQUEIDENTIFIER NOT NULL,
    [mrn_xid]          NVARCHAR (30)    NOT NULL,
    [patient_id]       UNIQUEIDENTIFIER NOT NULL,
    [orig_patient_id]  UNIQUEIDENTIFIER NULL,
    [merge_cd]         CHAR (1)         NOT NULL,
    [prior_patient_id] UNIQUEIDENTIFIER NULL,
    [mrn_xid2]         NVARCHAR (30)    NULL,
    [adt_adm_sw]       TINYINT          NULL
);




GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_mrn_map_mrn_xid_organization_id_patient_id_orig_patient_id]
    ON [dbo].[int_mrn_map]([mrn_xid] ASC, [organization_id] ASC, [patient_id] ASC, [orig_patient_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_mrn_map_merge_cd]
    ON [dbo].[int_mrn_map]([merge_cd] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_mrn_map_patient_id_merge_cd_mrn_xid2]
    ON [dbo].[int_mrn_map]([patient_id] ASC)
    INCLUDE([merge_cd], [mrn_xid2]) WITH (FILLFACTOR = 100);


GO
CREATE TRIGGER [dbo].[trig_mrn_map]
ON [dbo].[int_mrn_map]
FOR
INSERT, UPDATE
AS
INSERT INTO [dbo].[PatientSessionsMap]([PatientSessionId], [PatientId])
SELECT [PatientSessionId] = [LatestID1Assignment].[PatientSessionId]
      ,[PatientId] = inserted.[patient_id]
    FROM inserted
    INNER JOIN
    (
        SELECT [PatientSessionId]
              ,[ID1]
            FROM
            (
                SELECT [PatientSessionId]
                      ,[ID1]
                      ,[R] = ROW_NUMBER() OVER (PARTITION BY [PatientSessionId] ORDER BY [TimestampUTC] DESC)
                    FROM [dbo].[PatientData]
            ) AS [AssignmentSequence]
            WHERE [R] = 1
    ) AS [LatestID1Assignment]
        ON [ID1] = inserted.[mrn_xid]
    LEFT OUTER JOIN
    (
        SELECT [PatientSessionId]
              ,[PatientId]
              ,[R] = ROW_NUMBER() OVER (PARTITION BY [PatientSessionId] ORDER BY [Sequence] DESC)
            FROM [dbo].[PatientSessionsMap]
    ) AS [PatientSessionsMapSequence]
        ON [PatientSessionsMapSequence].[R]=1
        AND [PatientSessionsMapSequence].[PatientSessionId] = [LatestID1Assignment].[PatientSessionId]
        AND [PatientSessionsMapSequence].[PatientId] = inserted.[patient_id]
    WHERE [PatientSessionsMapSequence].[PatientSessionId] IS NULL
    AND inserted.[merge_cd] = 'C'

GO
/*procedures - updates for DM3--------end*/
-- Description:    Creates the Account Id record for the new patient based on int_mrn_map.mrn_xid2
CREATE TRIGGER [dbo].[TRG_UPDATE_HL7_ACCOUNT] ON [dbo].[int_mrn_map]
--WITH EXECUTE AS CALLER
    FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @act_xid NVARCHAR(40),
        @org_guid UNIQUEIDENTIFIER,
        @app_name VARCHAR(35);

    SET @app_name = APP_NAME();

    SELECT
        @act_xid = [Inserted].[mrn_xid2]
    FROM
        [Inserted];

    IF @act_xid = ''
        SET @act_xid = NULL;

    IF ((@app_name <> '.Net SqlClient Data Provider')
        AND (@act_xid IS NOT NULL)
        )
    BEGIN
        IF NOT EXISTS ( SELECT
                            [int_account].[account_xid]
                        FROM
                            [Inserted]
                            INNER JOIN [dbo].[int_encounter] ON ([Inserted].[patient_id] = [int_encounter].[patient_id])
                            INNER JOIN [dbo].[int_account] ON ([int_encounter].[account_id] = [int_account].[account_id])
                        WHERE
                            ([int_account].[account_xid] = [Inserted].[mrn_xid2])
                            AND ([int_encounter].[discharge_dt] IS NULL)
                            AND ([int_encounter].[patient_id] = [Inserted].[patient_id]) )
        BEGIN            

            SELECT
                @org_guid = [Inserted].[organization_id]
            FROM
                [Inserted];

            MERGE
                INTO [dbo].[int_account] AS [Dst]
                USING ( VALUES ( @act_xid ) ) AS [Src] ( [account_xid] )
                ON [Dst].[account_xid] = [Src].[account_xid]
                WHEN NOT MATCHED BY TARGET
                    THEN INSERT ( [account_id], [organization_id], [account_xid], [account_open_dt] )
                    VALUES ( NEWID(), @org_guid, @act_xid, GETDATE() )
                WHEN MATCHED
                    THEN UPDATE SET [organization_id] = @org_guid
            ;

        END;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to uniquely identify a medical record number to a PATIENT. This table allows the tracking of the MRNs assigned to a given PATIENT across time. This table takes an ORGANIZATION, their identifier and maps it into a uniquely generated patient ID (GUID). The assumption is that no matter how many MRN''s a patient is know by, there will only be one patient_id for that patient (especially since the MPI should handle minor inconsistencies with data-entry).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_mrn_map';

