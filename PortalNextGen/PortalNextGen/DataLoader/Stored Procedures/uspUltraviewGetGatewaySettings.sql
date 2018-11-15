CREATE PROCEDURE [DataLoader].[uspUltraviewGetGatewaySettings] (@GatewayType NVARCHAR(10))
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [dluts].[GatewayID],
            [dluts].[GatewayType],
            [dluts].[NetworkName],
            [dluts].[NetworkID],
            [dluts].[NodeName],
            [dluts].[NodeID],
            [dluts].[UvwOrganizationID],
            [dluts].[UvwUnitID],
            [dluts].[IncludeNodes],
            [dluts].[ExcludeNodes],
            [dluts].[UvwDoNotStoreWaveforms],
            [dluts].[PrintRequests],
            [dluts].[MakeTimeMaster],
            [dluts].[AutoAssignID],
            [dluts].[NewMedicalRecordNumberFormat],
            [dluts].[UvwPrintAlarms],
            [dluts].[DebugLevel]
        FROM
            [DataLoader].[UltraViewTemporarySettings] AS [dluts]
        WHERE
            [dluts].[GatewayType] = @GatewayType
        ORDER BY
            [dluts].[NetworkName];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DataLoader', @level1type = N'PROCEDURE', @level1name = N'uspUltraviewGetGatewaySettings';

