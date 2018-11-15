CREATE TYPE [old].[utpDeviceSessionData] AS TABLE (
    [DeviceSessionID]  INT           NOT NULL,
    [DeviceID]         INT           NOT NULL,
    [UniqueDeviceName] VARCHAR (50)  NOT NULL,
    [BeginDateTime]    DATETIME2 (7) NOT NULL,
    [EndDateTime]      DATETIME2 (7) NOT NULL);

