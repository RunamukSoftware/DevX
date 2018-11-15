CREATE PROCEDURE [dbo].[usp_DM3_AddMonitor]
    (
     @MonitorId NVARCHAR(50), -- TG - should be UNIQUEIDENTIFIER
     @Unit_Org_Id NVARCHAR(50) = NULL, -- TG - should be UNIQUEIDENTIFIER
     @Network_Id NVARCHAR(50),
     @Node_Id NVARCHAR(50), -- TG - should be NVARCHAR(15)
     @Monitor_Type_cd NVARCHAR(50) = NULL, -- TG - should be NVARCHAR(5)
     @Monitor_Name NVARCHAR(50),
     @Subnet NVARCHAR(20) = NULL
    )
AS
BEGIN
    INSERT  INTO [dbo].[int_monitor]
            ([monitor_id],
             [unit_org_id],
             [network_id],
             [node_id],
             [bed_id],
             [bed_cd],
             [room],
             [monitor_type_cd],
             [monitor_name],
             [subnet]
            )
    VALUES
            (CAST(@MonitorId AS UNIQUEIDENTIFIER),
             CAST(@Unit_Org_Id AS UNIQUEIDENTIFIER),
             CAST(@Network_Id AS NVARCHAR(15)),
             CAST(@Node_Id AS NVARCHAR(15)),
             N'0',
             N'0',
             N'0',
             CAST(@Monitor_Type_cd AS NVARCHAR(5)),
             CAST(@Monitor_Name AS NVARCHAR(30)),
             @Subnet
            );
    
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DM3_AddMonitor';

