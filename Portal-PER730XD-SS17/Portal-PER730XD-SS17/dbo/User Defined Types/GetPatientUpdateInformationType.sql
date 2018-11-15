CREATE TYPE [dbo].[GetPatientUpdateInformationType] AS TABLE (
    [DeviceId]         UNIQUEIDENTIFIER NOT NULL,
    [PatientSessionId] UNIQUEIDENTIFIER NOT NULL,
    [ID1]              VARCHAR (MAX)    NOT NULL);

