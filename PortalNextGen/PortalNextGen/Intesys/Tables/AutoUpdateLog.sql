CREATE TABLE [Intesys].[AutoUpdateLog] (
    [AutoUpdateLogID] INT           IDENTITY (1, 1) NOT NULL,
    [Machine]         NVARCHAR (50) NOT NULL,
    [ActionDateTime]  DATETIME2 (7) NOT NULL,
    [Product]         CHAR (3)      NOT NULL,
    [Success]         TINYINT       NOT NULL,
    [Reason]          NVARCHAR (80) NULL,
    [CreatedDateTime] DATETIME2 (7) CONSTRAINT [DF_AutoUpdateLog_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_AutoUpdateLog_AutoUpdateLogID] PRIMARY KEY CLUSTERED ([AutoUpdateLogID] ASC) WITH (FILLFACTOR = 100)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_AutoUpdateLog_Machine_ActionDateTime_Prod]
    ON [Intesys].[AutoUpdateLog]([Machine] ASC, [ActionDateTime] ASC, [Product] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table logs all successful and unsuccessful autoupdate attempts. Each client sends either an ACK or a NACK to the service, and the service then puts the appropriate row in the database. The intention is to use the OCX I wrote which views the log within MMC to have a realtime viewer of system updates.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdateLog';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP address or NT network name of machine that update was for.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdateLog', @level2type = N'COLUMN', @level2name = N'Machine';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date action was applied to machine', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdateLog', @level2type = N'COLUMN', @level2name = N'ActionDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Product that action applied to like CDR, CPI, ...', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdateLog', @level2type = N'COLUMN', @level2name = N'Product';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 if action was ACKed 0 if action was NACKed', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdateLog', @level2type = N'COLUMN', @level2name = N'Success';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains the error text passed from the client of action failed to be applied to that client. Example : Couldnt overwrite file Carewindow.exe, file in use.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'AutoUpdateLog', @level2type = N'COLUMN', @level2name = N'Reason';

