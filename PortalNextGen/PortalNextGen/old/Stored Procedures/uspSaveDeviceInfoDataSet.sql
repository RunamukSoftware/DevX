CREATE PROCEDURE [old].[uspSaveDeviceInfoDataSet] (@DeviceInfoData [old].[utpDeviceInfoDataSet] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [old].[DeviceInformation]
            (
                [DeviceInformationID],
                [DeviceSessionID],
                [Name],
                [Value],
                [DateTimeStamp]
            )
                    SELECT
                        [DeviceInfoDataID],
                        [DeviceSessionID],
                        [Name],
                        [Value],
                        [Timestamp]
                    FROM
                        @DeviceInfoData;

        /* If a patient admit was pending on the device org assignment arrival, then we
    	   create the MedicalRecordNumbermap row here.  The patient id might be already bound to the
	       patient session or not */
        MERGE INTO [Intesys].[MedicalRecordNumberMap] AS [Dest]
        USING
            (
                SELECT
                    ISNULL([PatientSessionsMapSequence].[PatientID], 0
                          --NEWID()
                          )                       AS [PatientID],
                    [Facilities].[OrganizationID] AS [FacilityID],
                    [LatestPatientData].[ID1]     AS [ID1],
                    [LatestPatientData].[ID2]     AS [ID2]
                FROM
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
                                                           [Timestamp] DESC
                                                      ) AS [r]
                                FROM
                                    @DeviceInfoData
                                WHERE
                                    [Name] = 'Unit'
                            ) AS [DeviceSessionFacilitySequence]
                        WHERE
                            [DeviceSessionFacilitySequence].[r] = 1
                    )                            AS [LatestDeviceSessionFacility]
                    INNER JOIN
                        [Intesys].[Organization] AS [Facilities]
                            ON [Facilities].[CategoryCode] = 'F'
                               AND [Facilities].[OrganizationName] = [LatestDeviceSessionFacility].[FacilityValue]
                    INNER JOIN
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
                                        [old].[Patient]
                                ) AS [PatientDataSequence]
                            WHERE
                                [PatientDataSequence].[r] = 1
                                AND [PatientDataSequence].[ID1] IS NOT NULL
                        )                        AS [LatestPatientData]
                            ON [LatestPatientData].[DeviceSessionID] = [LatestDeviceSessionFacility].[DeviceSessionID]
                    INNER JOIN
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
                        )                        AS [PatientSessionsMapSequence]
                            ON [PatientSessionsMapSequence].[r] = 1
                               AND [PatientSessionsMapSequence].[PatientSessionID] = [LatestPatientData].[PatientSessionID]
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
                                            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Save device information data set.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveDeviceInfoDataSet';

