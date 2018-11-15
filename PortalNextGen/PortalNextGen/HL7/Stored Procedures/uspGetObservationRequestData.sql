CREATE PROCEDURE [HL7].[uspGetObservationRequestData]
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN
            SELECT DISTINCT
                [OrderNumber].[Value]      AS [OrderID],
                [ig].[SendingApplication]  AS [SENDING_APPLICATION],
                CAST(NULL AS DATETIME2(7)) AS [ORDER_DATE_TIME]
            FROM
                [Intesys].[Gateway] AS [ig]
                CROSS JOIN
                    (
                        SELECT
                            [as].[Value]
                        FROM
                            [old].[ApplicationSetting] AS [as]
                        WHERE
                            [as].[Key] = 'DefaultFillerOrderNumber'
                    )               AS [OrderNumber];
        END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get HL7 observation request data.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetObservationRequestData';

