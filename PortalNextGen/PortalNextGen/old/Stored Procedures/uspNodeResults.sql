CREATE PROCEDURE [old].[uspNodeResults]
    (
        @PatientID       INT,
        @MinimumDateTime DATETIME2(7),
        @MaximumDateTime DATETIME2(7),
        @NodeID          INT = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @Level INT = 0;

        CREATE TABLE [#Nodes]
            (
                [NodeID]       INT,
                [Rank]         INT          NULL,
                [ParentNodeID] INT          NULL,
                [NodeName]     NVARCHAR(80) NULL,
                [Level]        INT
            );

        IF (@NodeID IS NULL)
            BEGIN
                INSERT INTO [#Nodes]
                    (
                        [NodeID],
                        [Rank],
                        [ParentNodeID],
                        [NodeName],
                        [Level]
                    )
                            SELECT
                                [itg].[NodeID],
                                [itg].[Rank],
                                [itg].[ParentNodeID],
                                [itg].[NodeName],
                                @Level AS [LEVEL]
                            FROM
                                [Intesys].[TestGroup] AS [itg]
                            WHERE
                                [itg].[ParentNodeID] IS NULL;
            END;
        ELSE
            BEGIN
                INSERT INTO [#Nodes]
                    (
                        [NodeID],
                        [Rank],
                        [ParentNodeID],
                        [NodeName],
                        [Level]
                    )
                            SELECT
                                [itg].[NodeID],
                                [itg].[Rank],
                                [itg].[ParentNodeID],
                                [itg].[NodeName],
                                @Level AS [LEVEL]
                            FROM
                                [Intesys].[TestGroup] AS [itg]
                            WHERE
                                [itg].[NodeID] = @NodeID;
            END;

        WHILE (@@ROWCOUNT <> 0)
            BEGIN
                SET @Level = @Level + 1;

                INSERT INTO [#Nodes]
                    (
                        [NodeID],
                        [Rank],
                        [ParentNodeID],
                        [NodeName],
                        [Level]
                    )
                            SELECT
                                [itg].[NodeID],
                                [itg].[Rank],
                                [itg].[ParentNodeID],
                                [itg].[NodeName],
                                @Level
                            FROM
                                [Intesys].[TestGroup] AS [itg]
                            WHERE
                                [itg].[ParentNodeID] IN (
                                                            SELECT
                                                                [NodeID]
                                                            FROM
                                                                [#Nodes]
                                                        )
                                AND [itg].[NodeID] NOT IN (
                                                              SELECT
                                                                  [NodeID]
                                                              FROM
                                                                  [#Nodes]
                                                          );
            END;

        /*
        SELECT
            [ResultID],
            [PatientID],
            [OriginalPatientID],
            [obs_startDateTime],
            [OrderID],
            [is_history],
            [MonitorSwitch],
            [univwsvcCodeID],
            [TestCodeID],
            [HistorySequence],
            [test_subID],
            [order_line_SequenceNumber],
            [test_result_SequenceNumber],
            [resultDateTime],
            [value_typeCode],
            [specimenID],
            [sourceCodeID],
            [StatusCodeID],
            [lastNumberrmalDateTime],
            [probability],
            [obsID],
            [prin_rslt_intprID],
            [asst_rslt_intprID],
            [techID],
            [trnscrbrID],
            [result_unitsCodeID],
            [reference_rangeID],
            [abnormalCode],
            [abnormal_natureCode],
            [provwsvcCodeID],
            [nsurvwtfr_ind],
            [result_value],
            [result_text],
            [result_comment],
            [has_history],
            [ModifiedDateTime],
            [mod_userID],
            [Sequence],
            [ResultDateTime]
        FROM
            [Intesys].[result]
        WHERE
            [PatientID] = @PatientID
            AND [obs_startDateTime] <= @MaximumDateTime
            AND [obs_startDateTime] >= @MinimumDateTime
            AND ([is_history] IS NULL
            OR [is_history] = 0
            );
        */

        SELECT
                [tn].[Rank]                                AS [NODERANK],
                [tn].[NodeID],
                [tn].[NodeName],
                [itgd].[AliasTestCodeID]                   AS [ALIAS],
                [itgd].[SourceCodeID]                      AS [TGD_SOURCECodeID],
                [itgd].[Rank]                              AS [DETRANK],
                [itgd].[Name],
                [itgd].[DisplayType],
                'rtTest'                                   AS [TEST_TYPE],
                [imc].[SystemID],
                [ir].[ObservationStartDateTime],
                [ir].[OrderID],
                [ir].[univwsvcCodeID],
                [ir].[TestCodeID],
                [ir].[HistorySequence],
                [ir].[test_subID],
                [ir].[OrderLineSequenceNumber],
                [ir].[TestResultSequenceNumber],
                [ir].[ResultDateTime],
                [ir].[ValueTypeCode],
                [ir].[SpecimenID],
                [ir].[SourceCodeID],
                [ir].[StatusCodeID],
                [ir].[ResultUnitsCodeID],
                [ir].[ReferenceRangeID],
                [ir].[AbnormalCode],
                [nsurvwtfr_ind],
                [ir].[PrincipalResultInterpretationID],
                [ir].[ResultValue],
                CONVERT(VARCHAR(10), [ir].[ResultComment]) AS [RESULT_COMMENT]
        INTO
            [#Result]
        FROM
                [#Nodes]                      AS [tn]
            INNER JOIN
                [Intesys].[TestGroupDetail]   AS [itgd]
                    ON [tn].[NodeID] = [itgd].[NodeID]
            INNER JOIN
                [Intesys].[Result]            AS [ir]
                    ON [itgd].[TestCodeID] = [ir].[TestCodeID]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [ir].[TestCodeID] = [imc].[CodeID]
        WHERE
                [ir].[PatientID] = @PatientID
                AND [ir].[ObservationStartDateTime] <= @MaximumDateTime
                AND [ir].[ObservationStartDateTime] >= @MinimumDateTime
                AND
                    (
                        ([ir].[IsHistory] IS NULL)
                        OR ([ir].[IsHistory] = 0)
                    )
        UNION
        SELECT DISTINCT
                [tn].[Rank]                                AS [NODERANK],
                [tn].[NodeID],
                [tn].[NodeName],
                [itgd].[AliasUnivwsvcCodeID]               AS [ALIAS],
                [itgd].[SourceCodeID]                      AS [TGD_SOURCECodeID],
                [itgd].[Rank]                              AS [DETRANK],
                [itgd].[Name],
                [itgd].[DisplayType],
                'rtUsid'                                   AS [TEST_TYPE],
                [imc].[SystemID],
                [ir].[ObservationStartDateTime],
                [ir].[OrderID],
                [ir].[univwsvcCodeID],
                NULL                                       AS [TestCodeID],
                [ir].[HistorySequence],
                NULL                                       AS [TEST_SUBID],
                [ir].[OrderLineSequenceNumber],
                NULL                                       AS [TEST_RESULT_SequenceNumber],
                [ir].[ResultDateTime],
                NULL                                       AS [ValueTypeCode],
                [ir].[SpecimenID],
                [ir].[SourceCodeID],
                NULL                                       AS [StatusCodeID],
                NULL                                       AS [RESULT_UNITSCodeID],
                NULL                                       AS [REFERENCE_RANGEID],
                [ir].[AbnormalCode],
                [nsurvwtfr_ind],
                [ir].[PrincipalResultInterpretationID],
                NULL                                       AS [RESULT_VALUE],
                CONVERT(VARCHAR(10), [ir].[ResultComment]) AS [RESULT_COMMENT]
        FROM
                [#Nodes]                      AS [tn]
            INNER JOIN
                [Intesys].[TestGroupDetail]   AS [itgd]
                    ON [tn].[NodeID] = [itgd].[NodeID]
            INNER JOIN
                [Intesys].[Result]            AS [ir]
                    ON [itgd].[univwsvcCodeID] = [ir].[univwsvcCodeID]
            INNER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [ir].[univwsvcCodeID] = [imc].[CodeID]
        WHERE
                [ir].[PatientID] = @PatientID
                AND [ir].[ObservationStartDateTime] <= @MaximumDateTime
                AND [ir].[ObservationStartDateTime] >= @MinimumDateTime
                AND
                    (
                        [ir].[IsHistory] IS NULL
                        OR [ir].[IsHistory] = 0
                    );

        SELECT DISTINCT
                [int_patient_image].[OrderID],
                1 AS [HAS_IMAGE]
        INTO
                [#Image]
        FROM
                [#Result]
            INNER JOIN
                [Intesys].[PatientImage]
                    ON [#Result].[OrderID] = [int_patient_image].[OrderID]
        WHERE
                [int_patient_image].[PatientID] = @PatientID;

        SELECT
                [tr].[NODERANK],
                [tr].[NodeID],
                [tr].[NodeName],
                [tr].[ALIAS],
                [tr].[TGD_SOURCECodeID],
                [tr].[DETRANK],
                [tr].[Name],
                [tr].[DisplayType],
                [tr].[TEST_TYPE],
                [tr].[SystemID],
                [tr].[ObservationStartDateTime],
                [tr].[OrderID],
                [tr].[univwsvcCodeID],
                [tr].[TestCodeID],
                [tr].[HistorySequence],
                [tr].[test_subID],
                [tr].[OrderLineSequenceNumber],
                [tr].[TestResultSequenceNumber],
                [tr].[ResultDateTime],
                [tr].[ValueTypeCode],
                [tr].[SpecimenID],
                [tr].[SourceCodeID],
                [tr].[StatusCodeID],
                [tr].[ResultUnitsCodeID],
                [tr].[ReferenceRangeID],
                [tr].[AbnormalCode],
                [tr].[nsurvwtfr_ind],
                [tr].[PrincipalResultInterpretationID],
                [tr].[ResultValue],
                [tr].[RESULT_COMMENT],
                [imc].[Code]        AS [SourceCode],
                [RR].[ReferenceRange],
                [PN].[LastName],
                [PN].[FirstName],
                [PN].[MiddleName],
                [PN].[Suffix],
                [io].[StatusCodeID] AS [OrderStatusCodeID],
                [HAS_IMAGE],
                [io].[EncounterID]
        FROM
                [#Result]                     AS [tr]
            LEFT OUTER JOIN
                [Intesys].[ReferenceRange]    AS [RR]
                    ON [tr].[ReferenceRangeID] = [RR].[ReferenceRangeID]
            LEFT OUTER JOIN
                [Intesys].[MiscellaneousCode] AS [imc]
                    ON [tr].[SourceCodeID] = [imc].[CodeID]
            LEFT OUTER JOIN
                [Intesys].[PersonName]        AS [PN]
                    ON [tr].[PrincipalResultInterpretationID] = [PN].[PersonNameID]
            LEFT OUTER JOIN
                [Intesys].[Order]             AS [io]
                    ON [tr].[OrderID] = [io].[OrderID]
            LEFT OUTER JOIN
                [#Image]
                    ON [tr].[OrderID] = [#Image].[OrderID];

        DROP TABLE [#Nodes];

        DROP TABLE [#Result];

        DROP TABLE [#Image];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspNodeResults';

