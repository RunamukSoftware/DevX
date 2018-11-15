CREATE TABLE [Intesys].[VitalLive] (
    [PatientID]          INT            NOT NULL,
    [OriginalPatientID]  INT            NULL,
    [MonitorID]          INT            NOT NULL,
    [CollectionDateTime] DATETIME2 (7)  NOT NULL,
    [VitalValue]         VARCHAR (4000) NOT NULL,
    [VitalTime]          VARCHAR (3950) NULL,
    [CreatedDateTime]    DATETIME2 (7)  CONSTRAINT [DF_VitalLive_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_VitalLive_PatientID_MonitorID_CollectionDateTime] PRIMARY KEY CLUSTERED ([PatientID] ASC, [MonitorID] ASC, [CollectionDateTime] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_VitalLive_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE TRIGGER [Intesys].[FillVitalCopyTempTable]
ON [Intesys].[VitalLive]
AFTER UPDATE, INSERT
AS
    BEGIN
        SET NOCOUNT ON;

        INSERT INTO [Intesys].[VitalLiveTemporary]
            (
                [PatientID],
                [OriginalPatientID],
                [MonitorID],
                [CollectionDateTime],
                [VitalValue],
                [VitalTime]
            )
                    SELECT
                        [Inserted].[PatientID],
                        [Inserted].[OriginalPatientID],
                        [Inserted].[MonitorID],
                        [Inserted].[CollectionDateTime],
                        [Inserted].[VitalValue],
                        [Inserted].[VitalTime]
                    FROM
                        [Inserted]
                    WHERE
                        [Inserted].[VitalTime] IS NOT NULL;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'VitalLive';

