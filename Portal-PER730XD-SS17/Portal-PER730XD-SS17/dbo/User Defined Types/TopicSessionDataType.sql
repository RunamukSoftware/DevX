CREATE TYPE [dbo].[TopicSessionDataType] AS TABLE (
    [Id]               UNIQUEIDENTIFIER NULL,
    [TopicTypeId]      UNIQUEIDENTIFIER NULL,
    [TopicInstanceId]  UNIQUEIDENTIFIER NULL,
    [DeviceSessionId]  UNIQUEIDENTIFIER NULL,
    [PatientSessionId] UNIQUEIDENTIFIER NULL,
    [BeginTimeUTC]     DATETIME         NULL,
    [EndTimeUTC]       DATETIME         NULL);

