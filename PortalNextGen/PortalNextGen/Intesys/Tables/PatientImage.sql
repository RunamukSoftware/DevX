CREATE TABLE [Intesys].[PatientImage] (
    [PatientImageID]    INT             IDENTITY (1, 1) NOT NULL,
    [PatientID]         INT             NOT NULL,
    [OrderID]           INT             NOT NULL,
    [SequenceNumber]    SMALLINT        NOT NULL,
    [OriginalPatientID] INT             NOT NULL,
    [ImageTypeCodeID]   INT             NOT NULL,
    [ImagePath]         NVARCHAR (255)  NOT NULL,
    [Image]             VARBINARY (MAX) NOT NULL,
    [CreatedDateTime]   DATETIME2 (7)   CONSTRAINT [DF_PatientImage_CreatedDateTime] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PatientImage_PatientImageID] PRIMARY KEY CLUSTERED ([PatientImageID] ASC) WITH (FILLFACTOR = 100),
    CONSTRAINT [FK_patient_image_Patient_PatientID] FOREIGN KEY ([PatientID]) REFERENCES [old].[Patient] ([PatientID])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_PatientImage_PatientID_OrderID_SequenceNumber]
    ON [Intesys].[PatientImage]([PatientID] ASC, [OrderID] ASC, [SequenceNumber] ASC) WITH (FILLFACTOR = 100);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Links Dome medical images to each patient. OrderID links the image to a specific order so that when viewing a report detail screen, we can display an image button if an image is present. The image button then displays all images for the current order.', @level0type = N'SCHEMA', @level0name = N'Intesys', @level1type = N'TABLE', @level1name = N'PatientImage';

