CREATE PROCEDURE [old].[uspGetLegacyPatientChannelList] (@PatientID INT)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT DISTINCT
            [ipc].[ChannelTypeID] AS [PatientChannelID],
            [ipc].[ChannelTypeID] AS [CHANNEL_TYPEID]
        FROM
            [Intesys].[PatientChannel] AS [ipc]
        WHERE
            [ipc].[PatientID] = @PatientID
            AND [ipc].[ActiveSwitch] = 1;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetLegacyPatientChannelList';

