CREATE PROCEDURE [dbo].[usp_SaveEndTopicSession]
    (
     @endTopicSessionData [dbo].TopicSessionDataType READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [dbo].[TopicSessions] AS [Target]
    USING @endTopicSessionData AS [Source]
    ON [Source].[Id] = [Target].[Id]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT
               ([Id], [EndTimeUTC])
        VALUES ([Source].[Id],
                [Source].[EndTimeUTC]
               )
    WHEN MATCHED THEN
        UPDATE SET
               [Target].[EndTimeUTC] = [Source].[EndTimeUTC];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveEndTopicSession';

