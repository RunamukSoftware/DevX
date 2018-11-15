CREATE TABLE [DataLoader].[UltraViewTemporarySettings] (
    [UltraViewTemporarySettingsID] INT            IDENTITY (1, 1) NOT NULL,
    [GatewayID]                    INT            NOT NULL,
    [GatewayType]                  NVARCHAR (20)  NOT NULL,
    [NetworkName]                  NVARCHAR (20)  NOT NULL,
    [NetworkID]                    NVARCHAR (30)  NOT NULL,
    [NodeName]                     CHAR (5)       NOT NULL,
    [NodeID]                       CHAR (1024)    NOT NULL,
    [UvwOrganizationID]            INT            NOT NULL,
    [UvwUnitID]                    INT            NOT NULL,
    [IncludeNodes]                 NVARCHAR (255) NOT NULL,
    [ExcludeNodes]                 NVARCHAR (255) NOT NULL,
    [UvwDoNotStoreWaveforms]       TINYINT        NOT NULL,
    [PrintRequests]                TINYINT        NOT NULL,
    [MakeTimeMaster]               TINYINT        NOT NULL,
    [AutoAssignID]                 TINYINT        NOT NULL,
    [NewMedicalRecordNumberFormat] NVARCHAR (30)  NOT NULL,
    [UvwPrintAlarms]               TINYINT        NOT NULL,
    [DebugLevel]                   INT            NOT NULL,
    [CreatedDateTime]              DATETIME2 (7)  CONSTRAINT [DF_UltraViewTemporarySettings_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_UltraViewTemporarySettings_UltraViewTemporarySettingsID] PRIMARY KEY CLUSTERED ([UltraViewTemporarySettingsID] ASC) WITH (FILLFACTOR = 100)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'DataLoader', @level1type = N'TABLE', @level1name = N'UltraViewTemporarySettings';

