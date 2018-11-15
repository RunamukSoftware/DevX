CREATE TYPE [dbo].[PatientSessionDataType] AS TABLE (
    [Id]           UNIQUEIDENTIFIER NULL,
    [BeginTimeUTC] DATETIME         NULL,
    [EndTimeUTC]   DATETIME         NULL);

