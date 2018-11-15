CREATE TYPE [old].[utpDeviceInfoDataSet] AS TABLE (
    [DeviceInfoDataID] INT           NOT NULL,
    [Name]             VARCHAR (25)  NOT NULL,
    [Value]            VARCHAR (100) NULL,
    [DeviceSessionID]  INT           NOT NULL,
    [Timestamp]        DATETIME2 (7) NOT NULL);

