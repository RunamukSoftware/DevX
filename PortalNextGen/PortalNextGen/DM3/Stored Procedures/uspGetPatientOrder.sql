CREATE PROCEDURE [DM3].[uspGetPatientOrder] (@EncounterID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [io].[EncounterID],
            [io].[OrderID],
            [io].[PatientID],
            [io].[OriginalPatientID],
            [io].[PriorityCodeID],
            [io].[StatusCodeID],
            [io].[OrderPersonID],
            [io].[OrderDateTime],
            [io].[EnterID],
            [io].[VerificationID],
            [io].[TranscriberID],
            [io].[ParentOrderID],
            [io].[ChildOrderSwitch],
            [io].[OrderControlCodeID],
            [io].[HistorySwitch],
            [io].[MonitorSwitch]
        FROM
            [Intesys].[Order] AS [io]
        WHERE
            [io].[EncounterID] = @EncounterID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientOrder';

