CREATE TABLE [Intesys].[VitalLiveTemporary] (
    [VitalLiveTemporaryID] BIGINT         IDENTITY (-9223372036854775808, 1) NOT NULL,
    [PatientID]            INT            NOT NULL,
    [OriginalPatientID]    INT            NULL,
    [MonitorID]            INT            NOT NULL,
    [CollectionDateTime]   DATETIME2 (7)  NOT NULL,
    [VitalValue]           VARCHAR (4000) NOT NULL,
    [VitalTime]            VARCHAR (3950) NOT NULL,
    [CreatedDateTime]      DATETIME2 (7)  CONSTRAINT [DF_VitalLiveTemporary_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_VitalLiveTemporary_VitalLiveTemporaryID] PRIMARY KEY CLUSTERED ([VitalLiveTemporaryID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_VitalLiveTemporary_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE NONCLUSTERED INDEX [IX_VitalLiveTemporary_CreatedDateTime]
    ON [Intesys].[VitalLiveTemporary]([CreatedDateTime] ASC) WITH (FILLFACTOR = 100);


GO
CREATE TRIGGER [Intesys].[trgRefreshVitalDataCopy]
ON [Intesys].[VitalLiveTemporary]
AFTER INSERT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Create the equivalent date time to (GETDATE( ) - 0.002)
        DECLARE @LowerTimeLimit DATETIME2(7) = DATEADD(MILLISECOND, -172800, SYSUTCDATETIME());

        --Keep data for two minutes most
        DELETE FROM
        [Intesys].[VitalLiveTemporary]
        WHERE
            [CreatedDateTime] < @LowerTimeLimit;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'<Table description here>', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'VitalLiveTemporary';

