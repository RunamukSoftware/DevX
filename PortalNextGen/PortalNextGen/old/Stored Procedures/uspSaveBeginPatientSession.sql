CREATE PROCEDURE [old].[uspSaveBeginPatientSession] (@BeginPatientSessionData [old].[utpPatientSession] READONLY)
AS
    BEGIN
        SET NOCOUNT ON;

        MERGE INTO [old].[PatientSession]
        USING @BeginPatientSessionData AS [Source]
        ON [Source].[PatientSessionID] = [PatientSession].[PatientSessionID]
        WHEN NOT MATCHED THEN INSERT
                                  (
                                      [PatientSessionID],
                                      [BeginDateTime]
                                  )
                              VALUES
                                  (
                                      [Source].[PatientSessionID], [Source].[BeginDateTime]
                                  )
        WHEN MATCHED
            THEN UPDATE SET
                     [EndDateTime] = NULL;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspSaveBeginPatientSession';

