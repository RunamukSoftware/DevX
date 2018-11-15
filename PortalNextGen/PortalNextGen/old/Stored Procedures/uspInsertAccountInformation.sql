CREATE PROCEDURE [old].[uspInsertAccountInformation]
    (
        @AccountID            INT,
        @OrganizationID       INT,
        @AccountNumber        NVARCHAR(40),
        @AccountStatusCodeID  INT          = NULL,
        @BadDebtSwitch        BIT,
        @TotPaymentsAmt       SMALLMONEY   = NULL,
        @TotChargesAmt        SMALLMONEY   = NULL,
        @TotAdjsAmt           SMALLMONEY   = NULL,
        @CurBalAmt            SMALLMONEY   = NULL,
        @AccountOpenDateTime  DATETIME2(7) = NULL,
        @AccountCloseDateTime DATETIME2(7) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@AccountOpenDateTime IS NULL)
            SET @AccountOpenDateTime = SYSUTCDATETIME();

        INSERT INTO [Intesys].[Account]
            (
                [AccountID],
                [OrganizationID],
                [AccountXID],
                [AccountStatusCodeID],
                [BadDebtSwitch],
                [TotalPaymentsAmount],
                [TotalChargesAmount],
                [TotalAdjustmentsAmount],
                [CurrentBalanceAmount],
                [AccountOpenDateTime],
                [AccountCloseDateTime]
            )
        VALUES
            (
                @AccountID, @OrganizationID, @AccountNumber, @AccountStatusCodeID, @BadDebtSwitch, @TotPaymentsAmt,
                @TotChargesAmt, @TotAdjsAmt, @CurBalAmt, @AccountOpenDateTime, @AccountCloseDateTime
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Insert Account Information from any component @AccountID, @OrganizationID, @AccountNumber are mandatory and the remaining are optional with default NULL values', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspInsertAccountInformation';

