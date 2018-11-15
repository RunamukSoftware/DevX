CREATE PROCEDURE [dbo].[usp_SaveBeginPatientSession]
    (
     @beginPatientSessionData [dbo].[PatientSessionDataType] READONLY
    )
AS
BEGIN
    SET NOCOUNT ON;
    
    MERGE INTO [dbo].[PatientSessions]
    USING @beginPatientSessionData AS [Source]
    ON [Source].[Id] = [PatientSessions].[Id]
    WHEN NOT MATCHED THEN
        INSERT
               ([Id], [BeginTimeUTC])
        VALUES ([Source].[Id],
                [Source].[BeginTimeUTC]
               )
    WHEN MATCHED THEN
        UPDATE SET
               [PatientSessions].[EndTimeUTC] = NULL;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SaveBeginPatientSession';

