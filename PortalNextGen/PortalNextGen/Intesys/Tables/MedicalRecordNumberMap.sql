CREATE TABLE [Intesys].[MedicalRecordNumberMap] (
    [MedicalRecordNumberMapID]          INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]                    INT           NOT NULL,
    [MedicalRecordNumberXID]            NVARCHAR (30) NOT NULL,
    [PatientID]                         INT           NOT NULL,
    [OriginalPatientID]                 INT           NULL,
    [MergeCode]                         CHAR (1)      NOT NULL,
    [PriorPatientID]                    INT           NULL,
    [MedicalRecordNumberXID2]           NVARCHAR (30) NULL,
    [AdmitDischargeTransferAdmitSwitch] BIT           NOT NULL,
    [CreatedDateTime]                   DATETIME2 (7) CONSTRAINT [DF_MedicalRecordNumberMap_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_MedicalRecordNumberMap_MedicalRecordNumberMapID] PRIMARY KEY CLUSTERED ([MedicalRecordNumberMapID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_MedicalRecordNumberMap_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID]),
    CONSTRAINT [FK_MedicalRecordNumberMap_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MedicalRecordNumberMap_MedicalRecordNumberxid_organizationID_PatientID_OriginalPatientID]
    ON [Intesys].[MedicalRecordNumberMap]([MedicalRecordNumberXID] ASC, [OrganizationID] ASC, [PatientID] ASC, [OriginalPatientID] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_MedicalRecordNumberMap_MergeCode]
    ON [Intesys].[MedicalRecordNumberMap]([MergeCode] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_MedicalRecordNumberMap_PatientID_MergeCode_MedicalRecordNumberXID2]
    ON [Intesys].[MedicalRecordNumberMap]([PatientID] ASC)
    INCLUDE([MergeCode], [MedicalRecordNumberXID2]) WITH (FILLFACTOR = 100);


GO
-- Description:    Creates the Account ID record for the new patient based on int_MedicalRecordNumbermap.MedicalRecordNumberXID2
CREATE TRIGGER [Intesys].[TRG_UPDATE_HL7_ACCOUNT]
ON [Intesys].[MedicalRecordNumberMap]
FOR INSERT, UPDATE
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @AccountXID      NVARCHAR(30),
            @OrganizationID  INT,
            @ApplicationName VARCHAR(35);

        SET @ApplicationName = APP_NAME();

        SELECT
            @AccountXID = [Inserted].[MedicalRecordNumberXID2]
        FROM
            [Inserted];

        IF (@AccountXID = '')
            SET @AccountXID = NULL;

        IF (
               @ApplicationName <> '.Net SqlClient Data Provider'
               AND @AccountXID IS NOT NULL
           )
            BEGIN
                IF NOT EXISTS
                    (
                        SELECT
                                [ia].[AccountXID]
                        FROM
                                [Inserted]
                            INNER JOIN
                                [Intesys].[Encounter] AS [ie]
                                    ON [Inserted].[PatientID] = [ie].[PatientID]
                            INNER JOIN
                                [Intesys].[Account]   AS [ia]
                                    ON [ie].[AccountID] = [ia].[AccountID]
                        WHERE
                                [ia].[AccountXID] = [Inserted].[MedicalRecordNumberXID2]
                                AND [ie].[DischargeDateTime] IS NULL
                                AND [ie].[PatientID] = [Inserted].[PatientID]
                    )
                    BEGIN

                        SELECT
                            @OrganizationID = [Inserted].[OrganizationID]
                        FROM
                            [Inserted];

                        MERGE INTO [Intesys].[Account] AS [Dst]
                        USING
                            (
                                VALUES
                                    (
                                        @AccountXID
                                    )
                            ) AS [src] ([AccountXID])
                        ON [Dst].[AccountXID] = [src].[AccountXID]
                        WHEN NOT MATCHED BY TARGET THEN INSERT
                                                            (
                                                                --[AccountID],
                                                                [OrganizationID],
                                                                [AccountXID],
                                                                [AccountOpenDateTime]
                                                            )
                                                        VALUES
                                                            (
                                                                --NEWID(), 
                                                                @OrganizationID, @AccountXID, SYSUTCDATETIME()
                                                            )
                        WHEN MATCHED
                            THEN UPDATE SET
                                     [Dst].[OrganizationID] = @OrganizationID;

                    END;
            END;
    END;
GO
CREATE TRIGGER [Intesys].[trgMedicalRecordNumberMap]
ON [Intesys].[MedicalRecordNumberMap]
FOR INSERT, UPDATE
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[PatientSessionMap]
            (
                [PatientID],
                [PatientSessionID]
            )
                    SELECT
                            [Inserted].[PatientID]                   AS [PatientID],
                            [LatestID1Assignment].[PatientSessionID] AS [PatientSessionID]
                    FROM
                            [Inserted]
                        INNER JOIN
                            (
                                SELECT
                                    [AssignmentSequence].[ID1],
                                    [AssignmentSequence].[PatientSessionID]
                                FROM
                                    (
                                        SELECT
                                            [p].[ID1],
                                            [p].[PatientSessionID],
                                            ROW_NUMBER() OVER (PARTITION BY
                                                                   [p].[PatientSessionID]
                                                               ORDER BY
                                                                   [p].[Timestamp] DESC
                                                              ) AS [r]
                                        FROM
                                            [old].[Patient] AS [p]
                                    ) AS [AssignmentSequence]
                                WHERE
                                    [AssignmentSequence].[r] = 1
                            ) AS [LatestID1Assignment]
                                ON [LatestID1Assignment].[ID1] = [Inserted].[MedicalRecordNumberXID]
                        LEFT OUTER JOIN
                            (
                                SELECT
                                    [psm].[PatientID],
                                    [psm].[PatientSessionID],
                                    ROW_NUMBER() OVER (PARTITION BY
                                                           [psm].[PatientSessionID]
                                                       ORDER BY
                                                           [psm].[PatientSessionMapID] DESC
                                                      ) AS [r]
                                FROM
                                    [old].[PatientSessionMap] AS [psm]
                            ) AS [PatientSessionsMapSequence]
                                ON [PatientSessionsMapSequence].[r] = 1
                                   AND [PatientSessionsMapSequence].[PatientSessionID] = [LatestID1Assignment].[PatientSessionID]
                                   AND [PatientSessionsMapSequence].[PatientID] = [Inserted].[PatientID]
                    WHERE
                            [PatientSessionsMapSequence].[PatientSessionID] IS NULL
                            AND [Inserted].[MergeCode] = 'C';
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table is used to uniquely identify a medical record number to a PATIENT. This table allows the tracking of the MRNs assigned to a given PATIENT across time. This table takes an ORGANIZATION, their identifier and maps it into a uniquely generated patient ID (GUID). The assumption is that no matter how many MRN''s a patient is know by, there will only be one PatientID for that patient (especially since the MPI should handle minor inconsistencies with data-entry).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'MedicalRecordNumberMap';

