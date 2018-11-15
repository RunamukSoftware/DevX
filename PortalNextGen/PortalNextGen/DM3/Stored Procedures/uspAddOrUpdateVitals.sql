CREATE PROCEDURE [DM3].[uspAddOrUpdateVitals]
    (
        @PatientID          INT,
        @MonitorID          INT,
        @CollectionDateTime DATETIME2(7),
        @VitalValue         VARCHAR(4000),
        @VitalTime          VARCHAR(3950) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS
            (
                SELECT
                    1
                FROM
                    [Intesys].[VitalLive] AS [ivl]
                WHERE
                    [ivl].[PatientID] = @PatientID
                    AND [ivl].[MonitorID] = @MonitorID
            )
            BEGIN
                UPDATE
                    [Intesys].[VitalLive]
                SET
                    [CollectionDateTime] = @CollectionDateTime,
                    [VitalValue] = @VitalValue,
                    [VitalTime] = @VitalTime
                WHERE
                    [PatientID] = @PatientID
                    AND [MonitorID] = @MonitorID;
            END;
        ELSE
            BEGIN
                INSERT INTO [Intesys].[VitalLive]
                    (
                        [PatientID],
                        [MonitorID],
                        [CollectionDateTime],
                        [VitalValue],
                        [VitalTime]
                    )
                VALUES
                    (
                        @PatientID,
                        @MonitorID,
                        @CollectionDateTime,
                        @VitalValue,
                        @VitalTime
                    );
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddOrUpdateVitals';

