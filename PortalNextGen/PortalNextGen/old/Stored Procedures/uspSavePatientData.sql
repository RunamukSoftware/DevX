CREATE PROCEDURE [old].[uspSavePatientData] (@PatientData [old].[utpPatient] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[Patient]
            (
                [PatientID],
                [PatientSessionID],
                [DeviceSessionID],
                [LastName],
                [MiddleName],
                [FirstName],
                [Gender],
                [ID1],
                [ID2],
                [DateOfBirth],
                [Weight],
                [WeightUnitOfMeasure],
                [Height],
                [HeightUnitOfMeasure],
                [BodySurfaceArea],
                [Location],
                [PatientType],
                [Timestamp]
            )
                    SELECT
                        [d].[PatientID],
                        [d].[PatientSessionID],
                        [d].[DeviceSessionID],
                        [d].[LastName],
                        [d].[MiddleName],
                        [d].[FirstName],
                        [d].[Gender],
                        [d].[ID1],
                        [d].[ID2],
                        [d].[DateOfBirth],
                        [d].[Weight],
                        [d].[WeightUOM],
                        [d].[Height],
                        [d].[HeightUOM],
                        [d].[BodySurfaceArea],
                        [d].[Location],
                        [d].[PatientType],
                        [d].[Timestamp]
                    FROM
                        @PatientData AS [d];

        /* Register the binding with the patient sessions */
        INSERT INTO [old].[PatientSessionMap]
            (
                [PatientSessionID],
                [PatientID]
            )
                    SELECT
                        [src].[PatientSessionID],
                        [src].[PatientID]
                    FROM
                        (
                            SELECT
                                [LatestPatientData].[PatientSessionID] AS [PatientSessionID],
                                COALESCE([imm].[PatientID], [PatientSessionsMapSequence].[PatientID], 0 --NEWID()
                                )                                      AS [PatientID]
                            FROM
                                /* The new data coming in */
                                (
                                    SELECT
                                        [PatientDataSequence].[PatientSessionID],
                                        [PatientDataSequence].[ID1]
                                    FROM
                                        (
                                            SELECT
                                                [PatientSessionID],
                                                [ID1],
                                                ROW_NUMBER() OVER (PARTITION BY
                                                                       [PatientSessionID]
                                                                   ORDER BY
                                                                       [Timestamp] DESC
                                                                  ) AS [r]
                                            FROM
                                                @PatientData
                                        ) AS [PatientDataSequence]
                                    WHERE
                                        [PatientDataSequence].[r] = 1
                                )                                      AS [LatestPatientData]
                                /* The patientID that's already associated with existing patient sessions */
                                LEFT OUTER JOIN
                                    (
                                        SELECT
                                            [psm].[PatientSessionID],
                                            [psm].[PatientID],
                                            ROW_NUMBER() OVER (PARTITION BY
                                                                   [psm].[PatientSessionID]
                                                               ORDER BY
                                                                   [psm].[PatientSessionMapID] DESC
                                                              ) AS [r]
                                        FROM
                                            [old].[PatientSessionMap] AS [psm]
                                    )                                  AS [PatientSessionsMapSequence]
                                        ON [PatientSessionsMapSequence].[r] = 1
                                           AND [PatientSessionsMapSequence].[PatientSessionID] = [LatestPatientData].[PatientSessionID]
                                           AND LEFT([LatestPatientData].[ID1], 1) <> '*' /* for incoming duplicated IDs, force a fresh patient GUID */
                                /* The patientID that's associated with the incoming ID1 */
                                LEFT OUTER JOIN
                                    [Intesys].[MedicalRecordNumberMap] AS [imm]
                                        ON [imm].[MedicalRecordNumberXID] = [LatestPatientData].[ID1]
                                           AND [imm].[MergeCode] = 'C'
                        )     AS [src]
                        /* Do not insert a new row when we are not updating the current binding */
                        LEFT OUTER JOIN
                            (
                                SELECT
                                    [PatientSessionID],
                                    [PatientID],
                                    ROW_NUMBER() OVER (PARTITION BY
                                                           [PatientSessionID]
                                                       ORDER BY
                                                           [PatientSessionMapID] DESC
                                                      ) AS [r]
                                FROM
                                    [old].[PatientSessionMap]
                            ) AS [PatientSessionsMapSequence]
                                ON [PatientSessionsMapSequence].[r] = 1
                                   AND [PatientSessionsMapSequence].[PatientSessionID] = [src].[PatientSessionID]
                                   AND [PatientSessionsMapSequence].[PatientID] = [src].[PatientID]
                    WHERE
                        [PatientSessionsMapSequence].[PatientSessionID] IS NULL;

        /* update the MedicalRecordNumbermap when we have the device org assignments */
        MERGE INTO [Intesys].[MedicalRecordNumberMap] AS [Dest]
        USING
            (
                SELECT
                    [io].[OrganizationID]                  AS [FacilityID],
                    [LatestPatientSessionsMap].[PatientID] AS [PatientID],
                    [LatestPatientData].[ID1],
                    [LatestPatientData].[ID2]
                FROM
                    (
                        SELECT
                            [PatientDataSequence].[PatientSessionID],
                            [PatientDataSequence].[DeviceSessionID],
                            [PatientDataSequence].[ID1],
                            [PatientDataSequence].[ID2]
                        FROM
                            (
                                SELECT
                                    [PatientSessionID],
                                    [DeviceSessionID],
                                    [ID1],
                                    [ID2],
                                    ROW_NUMBER() OVER (PARTITION BY
                                                           [PatientSessionID]
                                                       ORDER BY
                                                           [Timestamp] DESC
                                                      ) AS [r]
                                FROM
                                    @PatientData
                            ) AS [PatientDataSequence]
                        WHERE
                            [PatientDataSequence].[r] = 1
                            AND LTRIM(RTRIM(ISNULL([PatientDataSequence].[ID1], ''))) <> ''
                    )                            AS [LatestPatientData]
                    INNER JOIN
                        (
                            SELECT
                                [DeviceSessionFacilitySequence].[DeviceSessionID],
                                CASE
                                    WHEN CHARINDEX('+', [DeviceSessionFacilitySequence].[Value]) > 0
                                        THEN LEFT([DeviceSessionFacilitySequence].[Value], CHARINDEX(
                                                                                                        '+',
                                                                                                        [DeviceSessionFacilitySequence].[Value]
                                                                                                    ) - 1)
                                    ELSE
                                        NULL
                                END AS [FacilityValue]
                            FROM
                                (
                                    SELECT
                                        [DeviceSessionID],
                                        [Value],
                                        ROW_NUMBER() OVER (PARTITION BY
                                                               [DeviceSessionID]
                                                           ORDER BY
                                                               [DateTimeStamp] DESC
                                                          ) AS [r]
                                    FROM
                                        [old].[DeviceInformation]
                                    WHERE
                                        [Name] = 'Unit'
                                ) AS [DeviceSessionFacilitySequence]
                            WHERE
                                [DeviceSessionFacilitySequence].[r] = 1
                        )                        AS [LatestDeviceSessionFacility]
                            ON [LatestDeviceSessionFacility].[DeviceSessionID] = [LatestPatientData].[DeviceSessionID]
                    INNER JOIN
                        [Intesys].[Organization] AS [io]
                            ON [io].[OrganizationName] = [LatestDeviceSessionFacility].[FacilityValue]
                               AND [io].[CategoryCode] = 'F'
                    LEFT OUTER JOIN
                        (
                            SELECT
                                [PatientSessionsMapSequence].[PatientSessionID],
                                [PatientSessionsMapSequence].[PatientID]
                            FROM
                                (
                                    SELECT
                                        [PatientSessionID],
                                        [PatientID],
                                        ROW_NUMBER() OVER (PARTITION BY
                                                               [PatientSessionID]
                                                           ORDER BY
                                                               [PatientSessionMapID] DESC
                                                          ) AS [r]
                                    FROM
                                        [old].[PatientSessionMap]
                                ) AS [PatientSessionsMapSequence]
                            WHERE
                                [PatientSessionsMapSequence].[r] = 1
                        )                        AS [LatestPatientSessionsMap]
                            ON [LatestPatientSessionsMap].[PatientSessionID] = [LatestPatientData].[PatientSessionID]
            ) AS [src]
        ON [src].[PatientID] = [Dest].[PatientID]
           AND [Dest].[MergeCode] = 'C'
        WHEN NOT MATCHED BY TARGET THEN INSERT
                                            (
                                                [OrganizationID],
                                                [MedicalRecordNumberXID],
                                                [PatientID],
                                                [MergeCode],
                                                [MedicalRecordNumberXID2]
                                            )
                                        VALUES
                                            (
                                                [src].[FacilityID], [src].[ID1], [src].[PatientID], 'C', [src].[ID2]
                                            )
        WHEN MATCHED
            THEN UPDATE SET
                     [Dest].[MedicalRecordNumberXID2] = ISNULL(
                                                                  NULLIF([src].[ID2], ''),
                                                                  [Dest].[MedicalRecordNumberXID2]
                                                              ),
                     [Dest].[MedicalRecordNumberXID] = [src].[ID1];

        /* update int_patient.  we do this even if we don't have the MedicalRecordNumbermap record */
        MERGE INTO [Intesys].[Patient] AS [Dest]
        USING
            (
                SELECT
                    [LatestPatientSessionsMap].[PatientID],
                    [LatestPatientData].[DateOfBirth],
                    [imc].[CodeID] AS [GenderCodeID]
                FROM
                    (
                        SELECT
                            [PatientDataSequence].[PatientSessionID],
                            [PatientDataSequence].[ID1],
                            [PatientDataSequence].[Gender],
                            [PatientDataSequence].[DateOfBirth]
                        FROM
                            (
                                SELECT
                                    [PatientSessionID],
                                    [ID1],
                                    [Gender],
                                    [DateOfBirth],
                                    ROW_NUMBER() OVER (PARTITION BY
                                                           [PatientSessionID]
                                                       ORDER BY
                                                           [Timestamp] DESC
                                                      ) AS [r]
                                FROM
                                    @PatientData
                            ) AS [PatientDataSequence]
                        WHERE
                            [PatientDataSequence].[r] = 1
                            AND [PatientDataSequence].[ID1] IS NOT NULL
                    )                                 AS [LatestPatientData]
                    INNER JOIN
                        (
                            SELECT
                                [PatientSessionsMapSequence].[PatientSessionID],
                                [PatientSessionsMapSequence].[PatientID]
                            FROM
                                (
                                    SELECT
                                        [psm].[PatientSessionID],
                                        [psm].[PatientID],
                                        ROW_NUMBER() OVER (PARTITION BY
                                                               [psm].[PatientSessionID]
                                                           ORDER BY
                                                               [psm].[PatientSessionMapID] DESC
                                                          ) AS [r]
                                    FROM
                                        [old].[PatientSessionMap] AS [psm]
                                ) AS [PatientSessionsMapSequence]
                            WHERE
                                [PatientSessionsMapSequence].[r] = 1
                        )                             AS [LatestPatientSessionsMap]
                            ON [LatestPatientSessionsMap].[PatientSessionID] = [LatestPatientData].[PatientSessionID]
                    LEFT OUTER JOIN
                        [Intesys].[MiscellaneousCode] AS [imc]
                            ON [imc].[CategoryCode] = 'SEX'
                               AND [imc].[ShortDescription] = [LatestPatientData].[Gender]
            ) AS [src]
        ON [Dest].[PatientID] = [src].[PatientID]
        WHEN NOT MATCHED BY TARGET THEN INSERT
                                            (
                                                [PatientID],
                                                [DateOfBirth],
                                                [GenderCodeID]
                                            )
                                        VALUES
                                            (
                                                [src].[PatientID], [src].[DateOfBirth], [src].[GenderCodeID]
                                            )
        WHEN MATCHED
            THEN UPDATE SET
                     [Dest].[DateOfBirth] = ISNULL([src].[DateOfBirth], [Dest].[DateOfBirth]),
                     [Dest].[GenderCodeID] = ISNULL([src].[GenderCodeID], [Dest].[GenderCodeID]);

        /* update int_person.  we do this even if we don't have the MedicalRecordNumbermap record */
        MERGE INTO [Intesys].[Person] AS [Dest]
        USING
            (
                SELECT
                    [LatestPatientSessionsMap].[PatientID],
                    [LatestPatientData].[FirstName],
                    [LatestPatientData].[MiddleName],
                    [LatestPatientData].[LastName]
                FROM
                    (
                        SELECT
                            [PatientDataSequence].[PatientSessionID],
                            [PatientDataSequence].[ID1],
                            [PatientDataSequence].[FirstName],
                            [PatientDataSequence].[MiddleName],
                            [PatientDataSequence].[LastName]
                        FROM
                            (
                                SELECT
                                    [PatientSessionID],
                                    [ID1],
                                    [FirstName],
                                    [MiddleName],
                                    [LastName],
                                    ROW_NUMBER() OVER (PARTITION BY
                                                           [PatientSessionID]
                                                       ORDER BY
                                                           [Timestamp] DESC
                                                      ) AS [r]
                                FROM
                                    @PatientData
                            ) AS [PatientDataSequence]
                        WHERE
                            [PatientDataSequence].[r] = 1
                            AND [PatientDataSequence].[ID1] IS NOT NULL
                    )     AS [LatestPatientData]
                    INNER JOIN
                        (
                            SELECT
                                [PatientSessionsMapSequence].[PatientSessionID],
                                [PatientSessionsMapSequence].[PatientID]
                            FROM
                                (
                                    SELECT
                                        [PatientSessionID],
                                        [PatientID],
                                        ROW_NUMBER() OVER (PARTITION BY
                                                               [PatientSessionID]
                                                           ORDER BY
                                                               [PatientSessionMapID] DESC
                                                          ) AS [r]
                                    FROM
                                        [old].[PatientSessionMap]
                                ) AS [PatientSessionsMapSequence]
                            WHERE
                                [PatientSessionsMapSequence].[r] = 1
                        ) AS [LatestPatientSessionsMap]
                            ON [LatestPatientSessionsMap].[PatientSessionID] = [LatestPatientData].[PatientSessionID]
            ) AS [src]
        ON [Dest].[PersonID] = [src].[PatientID]
        WHEN NOT MATCHED BY TARGET
            THEN INSERT
                     (
                         [PersonID],
                         [FirstName],
                         [MiddleName],
                         [LastName]
                     )
                 VALUES
                     (
                         [src].[PatientID], [src].[FirstName], [src].[MiddleName], [src].[LastName]
                     )
        WHEN MATCHED
            THEN UPDATE SET
                     [Dest].[FirstName] = ISNULL(NULLIF([src].[FirstName], N''), [Dest].[FirstName]),
                     [Dest].[MiddleName] = ISNULL(NULLIF([src].[MiddleName], N''), [Dest].[MiddleName]),
                     [Dest].[LastName] = ISNULL(NULLIF([src].[LastName], N''), [Dest].[LastName]);
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save patient data - name, gender, weight, etc.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSavePatientData';

