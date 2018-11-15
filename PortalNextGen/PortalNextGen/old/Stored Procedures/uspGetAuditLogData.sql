CREATE PROCEDURE [old].[uspGetAuditLogData]
    (
        @StartDate   DATETIME2(7),
        @EndDate     DATETIME2(7),
        @ItemName    VARCHAR(256),
        @PatientID   INT,
        @Application VARCHAR(256),
        @DeviceName  VARCHAR(256)
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [al].[AuditID],
            [al].[AuditDateTime],
            [al].[PatientID],
            [al].[Application],
            [al].[DeviceName],
            [al].[Message],
            [al].[ItemName],
            [al].[OriginalValue],
            [al].[NewValue],
            [al].[HashedValue],
            [al].[ChangedBy]
        FROM
            [old].[AuditLog] AS [al]
        WHERE
            [al].[AuditDateTime] >= @StartDate
            AND [al].[AuditDateTime] <= @EndDate
            AND (
                    [al].[ItemName] = @ItemName
                    OR @ItemName IS NULL
                )
            AND (
                    [al].[PatientID] = @PatientID
                    OR @PatientID IS NULL
                )
            AND (
                    [al].[DeviceName] = @DeviceName
                    OR @DeviceName IS NULL
                )
            AND (
                    [al].[Application] = @Application
                    OR @Application IS NULL
                );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetAuditLogData';

