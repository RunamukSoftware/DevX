CREATE TABLE [dbo].[DeviceSession] (
    [DeviceSessionID]    BIGINT        NOT NULL,
    [MonitoringDeviceID] BIGINT        NOT NULL,
    [EncounterID]        INT           NOT NULL,
    [BeginDateTime]      DATETIME2 (7) NOT NULL,
    [EndDateTime]        DATETIME2 (7) NULL,
    [CreatedDateTime]    DATETIME2 (7) CONSTRAINT [DF_DeviceSession_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_DeviceSession_DeviceSessionID] PRIMARY KEY CLUSTERED ([DeviceSessionID] ASC),
    CONSTRAINT [FK_DeviceSession_Encounter_EncounterID] FOREIGN KEY ([EncounterID]) REFERENCES [dbo].[Encounter] ([EncounterID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A period of monitoring by a device.

    There is always an active session on a device.

    The session may or may not have a patient associated (Encounter) with it.  An anonymous session is a session with no associated patient. 

    When a patient is associated with device a new session is created (and the previous one ended)

    When a patient is dis-associated the active session is ended and new one created with no associated patient.

    The Clinical Mgmt Web App can be used to reconcile sessions with patients. For example it was known that a anonymous session actually had John Doe associated with it then it can be retroactively associated with John Doe.    Sessions can be split and merged to retroactively  fix up inconsistencies with P2DA.  
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeviceSession';

