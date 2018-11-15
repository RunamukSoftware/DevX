-- For rhythms, the category is 2 (Category_ECG_EVENT) 
-- The Type can be : (see vitals.h)
-- enum ECG_EVENT_TYPE
-- {…
-- ECG_EVENT_START_RHYTHM=3,
-- ECG_EVENT_END_RHYTHM=4,
-- ECG_EVENT_UPDATE_RHYTHM= 12,
-- …
-- }
-- The subType can be 
-- enum ECG_EVENT_SUBTYPE_RHYTHM
-- {
-- ECG_EVENT_SUBTYPE_RHY_NSR=1,
-- ECG_EVENT_SUBTYPE_RHY_STepis=2,
-- ECG_EVENT_SUBTYPE_RHY_Tepis=3,
-- ECG_EVENT_SUBTYPE_RHY_staxis=4,
-- ECG_EVENT_SUBTYPE_RHY_taxis=5,
-- ECG_EVENT_SUBTYPE_RHY_NOISE=6,
-- ECG_EVENT_SUBTYPE_RHY_ABIG=7,
-- ECG_EVENT_SUBTYPE_RHY_AFIB=8,
-- ECG_EVENT_SUBTYPE_RHY_AFL=9,
-- ECG_EVENT_SUBTYPE_RHY_VBIG=10,
-- ECG_EVENT_SUBTYPE_RHY_BII=11,
-- ECG_EVENT_SUBTYPE_RHY_B3=12,
-- ECG_EVENT_SUBTYPE_RHY_IVR=13,
-- ECG_EVENT_SUBTYPE_RHY_NOD=14,
-- ECG_EVENT_SUBTYPE_RHY_PAC=15,
-- ECG_EVENT_SUBTYPE_RHY_WPW=16,
-- ECG_EVENT_SUBTYPE_RHY_SAB=17,
-- ECG_EVENT_SUBTYPE_RHY_SBR=18,
-- ECG_EVENT_SUBTYPE_RHY_SVT=19,
-- ECG_EVENT_SUBTYPE_RHY_VTRIG=20,
-- ECG_EVENT_SUBTYPE_RHY_VFL=21,
-- ECG_EVENT_SUBTYPE_RHY_VTACH=22,
-- ECG_EVENT_SUBTYPE_RHY_MAT=23,
-- ECG_EVENT_SUBTYPE_RHY_LGL=24,
-- ECG_EVENT_SUBTYPE_RHY_AIVR=25,
-- ECG_EVENT_SUBTYPE_RHY_AVB2t1=26,
-- ECG_EVENT_SUBTYPE_RHY_AVB2t2=27,
-- ECG_EVENT_SUBTYPE_RHY_ATACH=28,
-- ECG_EVENT_SUBTYPE_RHY_SVRUN=29,
-- ECG_EVENT_SUBTYPE_RHY_MATBLK=30,
-- ECG_EVENT_SUBTYPE_RHY_B1=31,
-- ECG_EVENT_SUBTYPE_RHY_VFIB=32,
-- ECG_EVENT_SUBTYPE_RHY_IRR=33,
-- ECG_EVENT_SUBTYPE_RHY_UNK=34,
-- ECG_EVENT_SUBTYPE_RHY_NSRect=35,
-- ECG_EVENT_SUBTYPE_RHY_SBRect=36,
-- ECG_EVENT_SUBTYPE_RHY_STACHect=37,
-- ECG_EVENT_SUBTYPE_RHY_STACH=38,
-- ECG_EVENT_SUBTYPE_RHY_CPLT=39,
-- ECG_EVENT_SUBTYPE_RHY_ASYS=40,
-- ECG_EVENT_SUBTYPE_RHY_AVPAC=41,
-- ECG_EVENT_SUBTYPE_RHY_AVVPAC=42,
-- ECG_EVENT_SUBTYPE_RHY_PAUSE=43,
-- ECG_EVENT_SUBTYPE_RHY_MISSED=44
-- };

CREATE PROCEDURE [old].[uspGetEnhancedTelemetryEventsBySubtype]
    (
        @PatientID     INT,
        @Subtype       INT,
        @StartDateTime DATETIME2(7),
        @EndDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            ISNULL([EndOrUpdateEventsData].[Value1], [AllRhythmEvents].[StartValue1])         AS [VALUE1],       -- return the most recent available value  
            ISNULL([EndOrUpdateEventsData].[Value2], [AllRhythmEvents].[StartValue2])         AS [VALUE2],       -- return the most recent available value  
            ISNULL([EndOrUpdateEventsData].[Status], [AllRhythmEvents].[StartStatus])         AS [STATUS_VALUE], -- return the most recent available value  
            ISNULL([EndOrUpdateEventsData].[ValidLeads], [AllRhythmEvents].[StartValidLeads]) AS [LEADS],        -- return the most recent available value  
            [AllRhythmEvents].[StartTime],
            [AllRhythmEvents].[EndOrUpdateTime]
        FROM
            (
                SELECT
                    [EventsDataStart].[Value1]     AS [StartValue1],
                    [EventsDataStart].[Value2]     AS [StartValue2],
                    [EventsDataStart].[Status]     AS [StartStatus],
                    [EventsDataStart].[ValidLeads] AS [StartValidLeads],
                    [EventsDataStart].[TopicSessionID],
                    [EventsDataStart].[CategoryValue],
                    [EventsDataStart].[Subtype],
                    [EventsDataStart].[Timestamp]  AS [StartTime],
                    (
                        SELECT
                            COALESCE(
                                (
                                    SELECT TOP (1)
                                        [EventsDataEnd].[Timestamp]
                                    FROM
                                        [old].[Event] AS [EventsDataEnd]
                                    WHERE
                                        [EventsDataEnd].[Type] = 4
                                        AND [EventsDataEnd].[CategoryValue] = 2
                                        AND [EventsDataEnd].[Subtype] = @Subtype
                                        AND [EventsDataEnd].[TopicSessionID] = [EventsDataStart].[TopicSessionID]
                                        AND [EventsDataEnd].[Timestamp] > [EventsDataStart].[Timestamp]
                                    ORDER BY
                                        [EventsDataEnd].[Timestamp] ASC
                                ),
                                (
                                    SELECT TOP (1)
                                        [EventsDataUpdate].[Timestamp]
                                    FROM
                                        [old].[Event] AS [EventsDataUpdate]
                                    WHERE
                                        [EventsDataUpdate].[Type] = 12
                                        AND [EventsDataUpdate].[CategoryValue] = 2
                                        AND [EventsDataUpdate].[Subtype] = @Subtype
                                        AND [EventsDataUpdate].[TopicSessionID] = [EventsDataStart].[TopicSessionID]
                                        AND [EventsDataUpdate].[Timestamp] > [EventsDataStart].[Timestamp]
                                    ORDER BY
                                        [EventsDataUpdate].[Timestamp] DESC
                                ),
                                (
                                    SELECT
                                        [ts].[EndDateTime]
                                    FROM
                                        [old].[TopicSession] AS [ts]
                                    WHERE
                                        [ts].[TopicSessionID] = [EventsDataStart].[TopicSessionID]
                                ))
                    )                              AS [EndOrUpdateTime]
                FROM
                    [old].[Event]                      AS [EventsDataStart]
                    INNER JOIN
                        [old].[vwPatientTopicSessions] AS [vpts]
                            ON [vpts].[TopicSessionID] = [EventsDataStart].[TopicSessionID]
                WHERE
                    [vpts].[PatientID] = @PatientID
                    AND [EventsDataStart].[Type] = 3
                    AND [EventsDataStart].[CategoryValue] = 2
                    AND [EventsDataStart].[Subtype] = @Subtype
            )                 AS [AllRhythmEvents]
            LEFT OUTER JOIN
                [old].[Event] AS [EndOrUpdateEventsData]
                    ON [EndOrUpdateEventsData].[CategoryValue] = [AllRhythmEvents].[CategoryValue]
                       AND [EndOrUpdateEventsData].[Subtype] = [AllRhythmEvents].[Subtype]
                       AND [EndOrUpdateEventsData].[TopicSessionID] = [AllRhythmEvents].[TopicSessionID]
                       AND [EndOrUpdateEventsData].[Timestamp] = [AllRhythmEvents].[EndOrUpdateTime]
        WHERE
            (
                [AllRhythmEvents].[EndOrUpdateTime] IS NULL
                OR [AllRhythmEvents].[EndOrUpdateTime] > @StartDateTime
            );
    -- Do not filter out the start time of the event as we need to collect something when the request time 
    -- range is between an event start and end times, and we still need that active event to be returned
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Enhanced Telemetry (ET) events by subtype.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetEnhancedTelemetryEventsBySubtype';

