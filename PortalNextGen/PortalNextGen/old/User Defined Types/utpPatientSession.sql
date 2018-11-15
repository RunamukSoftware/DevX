CREATE TYPE [old].[utpPatientSession] AS TABLE (
    [PatientSessionID] INT           NOT NULL,
    [BeginDateTime]    DATETIME2 (7) NOT NULL,
    [EndDateTime]      DATETIME2 (7) NULL);

