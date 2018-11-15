CREATE PROCEDURE [HL7].[uspGetCommonOrderData]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (1)
           [OrderNumber].[Value] AS [OrderID],
           [ig].[SendingApplication] AS [SENDING_APPLICATION],
           [OrderStatus].[Value] AS [ORDER_STATUS],
           CAST(NULL AS DATETIME2(7)) AS [ORDER_DATE_TIME]
    FROM [Intesys].[Gateway] AS [ig]
        CROSS JOIN (SELECT [as].[Value]
                    FROM [old].[ApplicationSetting] AS [as]
                    WHERE [as].[Key] = 'DefaultFillerOrderStatus') AS [OrderStatus]
        CROSS JOIN (SELECT [as].[Value]
                    FROM [old].[ApplicationSetting] AS [as]
                    WHERE [as].[Key] = 'DefaultFillerOrderNumber') AS [OrderNumber];
END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the common order information for a given patient.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetCommonOrderData';

