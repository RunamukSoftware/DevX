CREATE PROCEDURE [old].[uspNodeDistribution]
    (
    @PatientID INT,
    @NodeID INT = NULL)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Level INT = 0;

    CREATE TABLE [#Nodes]
        ([NodeID] INT,
         [Rank] INT NULL,
         [ParentNodeID] INT NULL,
         [NodeName] NVARCHAR(80) NULL,
         [Level] INT);

    IF (@NodeID IS NULL)
    BEGIN
        INSERT INTO [#Nodes] ([NodeID],
                              [Rank],
                              [ParentNodeID],
                              [NodeName],
                              [Level])
        SELECT
            [tg].[NodeID],
            [tg].[Rank],
            [tg].[ParentNodeID],
            [tg].[NodeName],
            @Level AS [Level]
        FROM [Intesys].[TestGroup] AS [tg]
        WHERE [tg].[ParentNodeID] IS NULL;
    END;
    ELSE
    BEGIN
        INSERT INTO [#Nodes] ([NodeID],
                              [Rank],
                              [ParentNodeID],
                              [NodeName],
                              [Level])
        SELECT
            [tg].[NodeID],
            [tg].[Rank],
            [tg].[ParentNodeID],
            [tg].[NodeName],
            @Level AS [LEVEL]
        FROM [Intesys].[TestGroup] AS [tg]
        WHERE [tg].[NodeID] = @NodeID;
    END;

    WHILE (@@ROWCOUNT <> 0)
    BEGIN
        SET @Level = @Level + 1;

        INSERT INTO [#Nodes] ([NodeID],
                              [Rank],
                              [ParentNodeID],
                              [NodeName],
                              [Level])
        SELECT
            [tg].[NodeID],
            [tg].[Rank],
            [tg].[ParentNodeID],
            [tg].[NodeName],
            @Level
        FROM [Intesys].[TestGroup] AS [tg]
        WHERE [tg].[ParentNodeID] IN (SELECT [NodeID] FROM [#Nodes])
              AND [tg].[NodeID] NOT IN (SELECT [NodeID] FROM [#Nodes]);
    END;

    SELECT
        [tn].[Rank] AS [NODERANK],
        [tn].[NodeID],
        [tn].[NodeName],
        [itgd].[Rank] AS [DETRANK],
        [itgd].[Name],
        [itgd].[DisplayType],
        'rtTest' AS [TEST_TYPE],
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
        [ir].[nsurvwtfr_ind],
        [ir].[ResultValue]
    INTO [#Result]
    FROM [#Nodes] AS [tn]
        INNER JOIN [Intesys].[TestGroupDetail] AS [itgd]
            ON [tn].[NodeID] = [itgd].[NodeID]
        INNER JOIN [Intesys].[Result] AS [ir]
            ON [itgd].[TestCodeID] = [ir].[TestCodeID]
    WHERE [ir].[PatientID] = @PatientID
          AND ([ir].[IsHistory] IS NULL
               OR [ir].[IsHistory] = 0)
    UNION
    SELECT DISTINCT
           [tn].[Rank] AS [NODERANK],
           [tn].[NodeID],
           [tn].[NodeName],
           [itgd].[Rank] AS [DETRANK],
           [itgd].[Name],
           [itgd].[DisplayType],
           'rtUsID' AS [TEST_TYPE],
           [ir].[ObservationStartDateTime],
           [ir].[OrderID],
           [ir].[univwsvcCodeID],
           NULL AS [TestCodeID],
           [ir].[HistorySequence],
           NULL AS [TEST_SUBID],
           [ir].[OrderLineSequenceNumber],
           NULL AS [TEST_RESULT_SequenceNumber],
           [ir].[ResultDateTime],
           NULL AS [ValueTypeCode],
           [ir].[SpecimenID],
           [ir].[SourceCodeID],
           NULL AS [StatusCodeID],
           NULL AS [RESULT_UNITSCodeID],
           NULL AS [REFERENCE_RANGEID],
           [ir].[AbnormalCode],
           [ir].[nsurvwtfr_ind],
           NULL AS [RESULT_VALUE]
    FROM [#Nodes] AS [tn]
        INNER JOIN [Intesys].[TestGroupDetail] AS [itgd]
            ON [tn].[NodeID] = [itgd].[NodeID]
        INNER JOIN [Intesys].[Result] AS [ir]
            ON [itgd].[univwsvcCodeID] = [ir].[univwsvcCodeID]
    WHERE ([ir].[IsHistory] IS NULL
           OR [ir].[IsHistory] = 0)
          AND [ir].[PatientID] = @PatientID;

    SELECT
        [ObservationStartDateTime],
        COUNT(*) AS [CNT]
    FROM [#Result]
    GROUP BY [ObservationStartDateTime]
    ORDER BY [ObservationStartDateTime] DESC;

    /*
        SELECT
            univwsvc_cid,
            TestCodeID
        INTO #tmp_details
        FROM dbo.cdr_test_group_detail,
             #tmpNumberdes
        WHERE cdr_test_group_detail.NodeID = #tmpNumberdes.NodeID

        SELECT
            obs_start_dt,
            TestCodeID,
            univwsvc_cid,
            count(*) cnt
        INTO #tmp_results
        FROM [Intesys].[Result]
        WHERE PatientID = @PatientID
              AND is_history IS NULL
        GROUP BY obs_start_dt,
                 TestCodeID,
                 univwsvc_cid

        SELECT
            obs_start_dt,
            cnt
        INTO #tmp_answer
        FROM #tmp_results,
             #tmp_details
        WHERE #tmp_results.TestCodeID = #tmp_details.TestCodeID
        UNION ALL
        SELECT
            obs_start_dt,
            cnt
        FROM #tmp_results,
             #tmp_details
        WHERE #tmp_results.univwsvc_cid = #tmp_details.univwsvc_cid

        SELECT
            obs_start_dt,
            sum(cnt) cnt
        FROM #tmp_answer
        GROUP BY obs_start_dt
        ORDER BY obs_start_dt DESC

        DROP TABLE #tmp_details
        */

    DROP TABLE [#Nodes];

    DROP TABLE [#Result];
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspNodeDistribution';

