CREATE PROCEDURE [dbo].[usp_HL7_GetCommonOrderData]
AS
BEGIN
    SELECT TOP (1)
        [OrderNumber].[Value] AS [ORDER_ID],
        [ig].[send_app] AS [SENDING_APPLICATION],
        [OrderStatus].[Value] AS [ORDER_STATUS],
        CAST(NULL AS DATETIME) AS [ORDER_DATE_TIME]
    FROM
        [dbo].[int_gateway] AS [ig]
        CROSS JOIN (SELECT
                        [as].[Value]
                    FROM
                        [dbo].[ApplicationSettings] AS [as]
                    WHERE
                        [as].[Key] = 'DefaultFillerOrderStatus'
                   ) AS [OrderStatus]
        CROSS JOIN (SELECT
                        [as].[Value]
                    FROM
                        [dbo].[ApplicationSettings] AS [as]
                    WHERE
                        [as].[Key] = 'DefaultFillerOrderNumber'
                   ) AS [OrderNumber];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Retrieves the common order information for a given patient.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetCommonOrderData';

