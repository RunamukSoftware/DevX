CREATE TABLE [dbo].[int_account] (
    [account_id]         UNIQUEIDENTIFIER NOT NULL,
    [organization_id]    UNIQUEIDENTIFIER NOT NULL,
    [account_xid]        NVARCHAR (40)    NOT NULL,
    [account_status_cid] INT              NULL,
    [bad_debt_sw]        TINYINT          NULL,
    [tot_payments_amt]   SMALLMONEY       NULL,
    [tot_charges_amt]    SMALLMONEY       NULL,
    [tot_adjs_amt]       SMALLMONEY       NULL,
    [cur_bal_amt]        SMALLMONEY       NULL,
    [account_open_dt]    DATETIME         NULL,
    [account_close_dt]   DATETIME         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [CL_int_account_account_id]
    ON [dbo].[int_account]([account_id] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_int_account_account_xid]
    ON [dbo].[int_account]([account_xid] ASC, [organization_id] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This table stores accounts associated with patients. HL/7 defines most of the account information in the PV1 segment. While P01 events contain the account details, summary level information is contained in the PV1 (which this table stores).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The unique ID for this account. It is a system generated GUID that is guaranteed to always be unique.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'account_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The organization this account belongs to (one that created the account). FK to the organization table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'organization_id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The external ACCOUNT number within the ORGANIZATION that owns the ACCOUNT. This is the account number that the facility/organization knows.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'account_xid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A code that identifies the state that the ACCOUNT is in. This is defined in HL/7 (PV1).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'account_status_cid';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'A YES/NO flag that identifies an ACCOUNT is in delinquent status. If the transfer amount is greater than zero, the BAD_DEBT_SW will be set to (1). This is defined in the PV1 segment.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'bad_debt_sw';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The total amount paid to a unique ACCOUNT. Defined in HL/7 (PV1).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'tot_payments_amt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The amount that contains the total amount of charges for an ACCOUNT Defined in HL/7 (PV1)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'tot_charges_amt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The amount that was adjusted towards a unique ACCOUNT. Defined in HL/7 (PV1)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'tot_adjs_amt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The amount due for an ENCOUNTER. Sometimes referred to as the ''ACCOUNT BALANCE''. Defined in HL/7 (PV1)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'cur_bal_amt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field identifies the date the account was opened.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'account_open_dt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This field identifies the date the account was closed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'int_account', @level2type = N'COLUMN', @level2name = N'account_close_dt';

