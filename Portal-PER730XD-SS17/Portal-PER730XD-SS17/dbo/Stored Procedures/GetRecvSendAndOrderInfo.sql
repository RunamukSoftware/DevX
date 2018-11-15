CREATE PROCEDURE [dbo].[GetRecvSendAndOrderInfo]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [recv_app] AS [RECVAPP],
        [send_app] AS [SENDAPP],
        [order_xid] AS [ORDERXID],
        [send_app] AS [SENDAPP],
        [univ_svc_cid] AS [ORDERSTATUS],
        [int_order].[order_dt] AS [TRANSDATETIME]
    FROM
        [dbo].[int_gateway]
        INNER JOIN [dbo].[int_monitor] ON [int_gateway].[network_id] = [int_monitor].[network_id]
        INNER JOIN [dbo].[int_patient_monitor] ON [int_monitor].[monitor_id] = [int_patient_monitor].[monitor_id]
        INNER JOIN [dbo].[int_order_map] ON [int_gateway].[send_sys_id] = [int_order_map].[sys_id]
        INNER JOIN [dbo].[int_order] ON [int_patient_monitor].[patient_id] = [int_order].[patient_id]
                                        AND [int_order].[order_id] = [int_order_map].[order_id]
    WHERE
        [int_gateway].[gateway_type] <> 'S5N'
        AND [int_patient_monitor].[patient_id] = @patient_id;
           --AND int_patient_monitor.active_sw=1 
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetRecvSendAndOrderInfo';

