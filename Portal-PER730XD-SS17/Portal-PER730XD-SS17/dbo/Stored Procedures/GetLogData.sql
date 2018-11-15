CREATE PROCEDURE [dbo].[GetLogData]
    (
     @StartDate DATETIME,
     @EndDate DATETIME,
     @LogType VARCHAR(64),
     @PatientId [dbo].[DPATIENT_ID], -- TG - Should be UNIQUEIDENTIFIER
     @Application VARCHAR(256),
     @DeviceName VARCHAR(256)
    )
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [LogId],
        [DateTime],
        [PatientID],
        [Application],
        [DeviceName],
        [Message],
        [LocalizedMessage],
        [MessageId],
        [LogType]
    FROM
        [dbo].[LogData]
    WHERE
        [DateTime] >= @StartDate
        AND [DateTime] <= @EndDate
        AND ([LogType] = @LogType
        OR @LogType IS NULL
        )
        AND ([PatientID] = @PatientId
        OR @PatientId IS NULL
        )
        AND ([DeviceName] = @DeviceName
        OR @DeviceName IS NULL
        )
        AND ([Application] = @Application
        OR @Application IS NULL
        );
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'GetLogData';

