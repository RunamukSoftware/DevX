CREATE PROCEDURE [dbo].[usp_HL7_GetObservationRequestData]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN
        SELECT DISTINCT
            [OrderNumber].[Value] AS [ORDER_ID],
            [ig].[send_app] AS [SENDING_APPLICATION],
            CAST(NULL AS DATETIME) AS [ORDER_DATE_TIME]
        FROM
            [dbo].[int_gateway] AS [ig]
            CROSS JOIN (SELECT
                            [as].[Value]
                        FROM
                            [dbo].[ApplicationSettings] AS [as]
                        WHERE
                            [as].[Key] = 'DefaultFillerOrderNumber'
                       ) AS [OrderNumber];
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get HL7 observation request data.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_GetObservationRequestData';

