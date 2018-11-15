CREATE PROCEDURE [Purger].[uspPurgeTwelveLeadData]
    (
        @ChunkSize            INT,
        @PurgeDate            DATETIME2(7),
        @TwelveLeadRowsPurged INT OUTPUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @RC INT = 0;
        DECLARE @Loop INT = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [isew]
                FROM
                    [Intesys].[SavedEventWaveform] AS [isew]
                    INNER JOIN
                        [Intesys].[UserSavedEvent] AS [ise]
                            ON [isew].[EventID] = [ise].[EventID]
                               AND [isew].[PatientID] = [ise].[PatientID]
                WHERE
                    [ise].[InsertDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        -- Nancy on 2/28/08, Fix for CR Isq#2661
        -- Don't handle parent table data here since other child table data need them 
        --    SET ROWCOUNT 0
        --    DELETE FROM [Intesys].[patient_monitor]
        --    FROM [Intesys].[encounter] ie
        --    WHERE PatientMonitor.EncounterID = ie.EncounterID
        --    AND discharge_dt < @PurgeDate
        --    AND ISNULL(ActiveSwitch, 0) = 0;
        --    SET @RC += @@ROWCOUNT;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ilre]
                FROM
                    [Intesys].[TwelveLeadReportEdit]   AS [ilre]
                    INNER JOIN
                        [Intesys].[TwelveLeadReport] AS [i12r]
                            ON [ilre].[ReportID] = [i12r].[ReportID]
                WHERE
                    [i12r].[ReportDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ipt]
                FROM
                    [Intesys].[ParameterTimeTag] AS [ipt]
                WHERE
                    [ipt].[ParamDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ise]
                FROM
                    [Intesys].[PatientSavedEvent] AS [ise]
                WHERE
                    [ise].[InsertDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @Loop = 1;

        WHILE (@Loop > 0)
            BEGIN
                DELETE TOP (@ChunkSize)
                [ilr]
                FROM
                    [Intesys].[TwelveLeadReport] AS [ilr]
                WHERE
                    [ilr].[ReportDateTime] < @PurgeDate;

                SET @Loop = @@ROWCOUNT;
                SET @RC += @Loop;
            END;

        SET @TwelveLeadRowsPurged = @RC;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'Purger', @level1type = N'PROCEDURE', @level1name = N'uspPurgeTwelveLeadData';

