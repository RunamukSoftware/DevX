CREATE PROCEDURE [old].[uspGetReceiveSendAndOrderInformation] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [ig].[ReceivingApplication]           AS [RECVAPP],
            [ig].[SendingApplication] AS [SENDAPP],
            [iom].[OrderXID]          AS [ORDERXID],
            [ig].[SendingApplication] AS [SENDAPP],
            [io].[OrderDateTime]      AS [TRANSDATETIME]
        FROM
            [Intesys].[Gateway]            AS [ig]
            INNER JOIN
                [Intesys].[Monitor]        AS [im]
                    ON [ig].[NetworkID] = [im].[NetworkID]
            INNER JOIN
                [Intesys].[PatientMonitor] AS [ipm]
                    ON [im].[MonitorID] = [ipm].[MonitorID]
            INNER JOIN
                [Intesys].[OrderMap]       AS [iom]
                    ON [ig].[SendSystemID] = [iom].[SystemID]
            INNER JOIN
                [Intesys].[Order]          AS [io]
                    ON [ipm].[PatientID] = [io].[PatientID]
                       AND [io].[OrderID] = [iom].[OrderID]
        WHERE
            [ig].[GatewayType] <> 'S5N'
            AND [ipm].[PatientID] = @PatientID;
    --AND [ipm].[ActiveSwitch] = 1
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetReceiveSendAndOrderInformation';

