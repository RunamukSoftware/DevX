CREATE PROCEDURE [HL7].[uspUpdateAccountInformation]
    (
        @AccountID              INT,
        @AccountStatusCodeID    INT,
        @BadDebtSwitch          BIT,
        @TotalPaymentsAmount    SMALLMONEY,
        @TotalChargesAmount     SMALLMONEY,
        @TotalAdjustmentsAmount SMALLMONEY,
        @CurrentBalanceAmount   SMALLMONEY,
        @AccountCloseDateTime   DATETIME2(7)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Account]
        SET
            [AccountStatusCodeID] = @AccountStatusCodeID,
            [BadDebtSwitch] = @BadDebtSwitch,
            [TotalPaymentsAmount] = @TotalPaymentsAmount,
            [TotalChargesAmount] = @TotalChargesAmount,
            [TotalAdjustmentsAmount] = @TotalAdjustmentsAmount,
            [CurrentBalanceAmount] = @CurrentBalanceAmount,
            [AccountCloseDateTime] = @AccountCloseDateTime
        WHERE
            [AccountID] = @AccountID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Update the patient Account Information from HL7 component.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateAccountInformation';

