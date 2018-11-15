CREATE PROCEDURE [dbo].[usp_SaveEndPatientSession]
    (
     @endPatientSessionData [dbo].[PatientSessionDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE
        [dbo].[PatientSessions]
    SET
        [EndTimeUTC] = [x].[EndTimeUTC]
    FROM
        @endPatientSessionData AS [x]
    WHERE
        [PatientSessions].[Id] = [x].[Id]
        AND [PatientSessions].[EndTimeUTC] IS NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveEndPatientSession';

