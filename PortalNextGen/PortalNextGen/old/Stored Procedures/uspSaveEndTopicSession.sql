CREATE PROCEDURE [old].[uspSaveEndTopicSession] (@endTopicSessionData [old].[utpTopicSession] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        MERGE INTO [old].[TopicSession] AS [Target]
        USING @endTopicSessionData AS [Source]
        ON [Source].[TopicSessionID] = [Target].[TopicSessionID]
        WHEN NOT MATCHED BY TARGET THEN INSERT
                                            (
                                                [TopicSessionID],
                                                [EndDateTime]
                                            )
                                        VALUES
                                            (
                                                [Source].[TopicSessionID], [Source].[EndDateTime]
                                            )
        WHEN MATCHED
            THEN UPDATE SET
                     [Target].[EndDateTime] = [Source].[EndDateTime];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveEndTopicSession';

