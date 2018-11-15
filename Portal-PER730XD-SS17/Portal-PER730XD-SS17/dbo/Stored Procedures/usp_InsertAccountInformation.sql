CREATE PROCEDURE [dbo].[usp_InsertAccountInformation]
    (
     @AccountId UNIQUEIDENTIFIER,
     @orgId UNIQUEIDENTIFIER,
     @accountNumber NVARCHAR(80), -- TG - Should be NVARCHAR(40)
     @accountStatusCid INT = NULL,
     @badDebtSw TINYINT = NULL,
     @totPaymentsAmt SMALLMONEY = NULL,
     @totChargesAmt SMALLMONEY = NULL,
     @totAdjsAmt SMALLMONEY = NULL,
     @curBalAmt SMALLMONEY = NULL,
     @accountOpenDt DATETIME = NULL,
     @accountCloseDt DATETIME = NULL
    )
AS
BEGIN
    IF @accountOpenDt IS NULL
        SET @accountOpenDt = GETDATE();

    INSERT  INTO [dbo].[int_account]
            ([account_id],
             [organization_id],
             [account_xid],
             [account_status_cid],
             [bad_debt_sw],
             [tot_payments_amt],
             [tot_charges_amt],
             [tot_adjs_amt],
             [cur_bal_amt],
             [account_open_dt],
             [account_close_dt]
            )
    VALUES
            (@AccountId,
             @orgId,
             CAST(@accountNumber AS NVARCHAR(40)),
             @accountStatusCid,
             @badDebtSw,
             @totPaymentsAmt,
             @totChargesAmt,
             @totAdjsAmt,
             @curBalAmt,
             @accountOpenDt,
             @accountCloseDt
            );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert Account Information from any component @AccountId, @orgId, @accountNumber are mandatory and the remaining are optional with default NULL values', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_InsertAccountInformation';

