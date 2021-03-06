﻿CREATE PROCEDURE [old].[uspGetPatientSavedEventLeadLog]
    (
        @PatientID         INT,
        @EventID AS        INT,
        @PrimaryChannel AS BIT,
        @TimeTagType AS    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [isel].[LeadType] AS [LEADTYPE],
            [isel].[start_ms] AS [STARTMS]
        FROM
            [Intesys].[SavedEventLog] AS [isel]
        WHERE
            [isel].[PatientID] = @PatientID
            AND [isel].[EventID] = @EventID
            AND [isel].[PrimaryChannel] = @PrimaryChannel
            AND [isel].[TimeTagType] = @TimeTagType;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetPatientSavedEventLeadLog';

