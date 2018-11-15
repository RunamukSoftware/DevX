CREATE TABLE [Intesys].[Account] (
    [AccountID]              INT           IDENTITY (1, 1) NOT NULL,
    [OrganizationID]         INT           NOT NULL,
    [AccountXID]             NVARCHAR (40) NOT NULL,
    [AccountStatusCodeID]    INT           NOT NULL,
    [BadDebtSwitch]          BIT           NOT NULL,
    [TotalPaymentsAmount]    SMALLMONEY    NOT NULL,
    [TotalChargesAmount]     SMALLMONEY    NOT NULL,
    [TotalAdjustmentsAmount] SMALLMONEY    NOT NULL,
    [CurrentBalanceAmount]   SMALLMONEY    NOT NULL,
    [AccountOpenDateTime]    DATETIME2 (7) NOT NULL,
    [AccountCloseDateTime]   DATETIME2 (7) NOT NULL,
    [CreatedDateTime]        DATETIME2 (7) CONSTRAINT [DF_Account_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_Account_AccountID] PRIMARY KEY CLUSTERED ([AccountID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_Account_Organization_OrganizationID] FOREIGN KEY ([OrganizationID]) REFERENCES [Intesys].[Organization] ([OrganizationID])
);


GO
CREATE NONCLUSTERED INDEX [IX_Account_AccountXID]
    ON [Intesys].[Account]([AccountXID] ASC, [OrganizationID] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores accounts associated with patients. HL/7 defines most of the account information in the PV1 segment. While P01 events contain the account details, summary level information is contained in the PV1 (which this table stores).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID for this account. It is a system generated GUID that is guaranteed to always be unique.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'AccountID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization this account belongs to (one that created the account). FK to the organization table.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'OrganizationID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The external ACCOUNT number within the ORGANIZATION that owns the ACCOUNT. This is the account number that the facility/organization knows.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'AccountXID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the state that the ACCOUNT is in. This is defined in HL/7 (PV1).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'AccountStatusCodeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A YES/NO flag that identifies an ACCOUNT is in delinquent status. If the transfer amount is greater than zero, the BadDebtSwitch will be set to (1). This is defined in the PV1 segment.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'BadDebtSwitch';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The total amount paid to a unique ACCOUNT. Defined in HL/7 (PV1).', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'TotalPaymentsAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The amount that contains the total amount of charges for an ACCOUNT Defined in HL/7 (PV1)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'TotalChargesAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The amount that was adjusted towards a unique ACCOUNT. Defined in HL/7 (PV1)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'TotalAdjustmentsAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The amount due for an ENCOUNTER. Sometimes referred to as the ''ACCOUNT BALANCE''. Defined in HL/7 (PV1)', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'CurrentBalanceAmount';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field identifies the date the account was opened.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'AccountOpenDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field identifies the date the account was closed.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'Account', @level2type = N'COLUMN', @level2name = N'AccountCloseDateTime';

