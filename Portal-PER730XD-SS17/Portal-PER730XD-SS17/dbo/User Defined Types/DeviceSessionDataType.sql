CREATE TYPE [dbo].[DeviceSessionDataType] AS TABLE (
    [Id]               UNIQUEIDENTIFIER NULL,
    [DeviceId]         UNIQUEIDENTIFIER NULL,
    [UniqueDeviceName] VARCHAR (50)     NULL,
    [BeginTimeUTC]     DATETIME         NULL,
    [EndTimeUTC]       DATETIME         NULL);

