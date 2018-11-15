CREATE PROCEDURE [DM3].[uspAddPatientOrder]
    (
        @OrderID     INT              = NULL,
        @PatientID   INT              = NULL,
        @Result_usid INT              = NULL,
        @EncounterID INT              = NULL,
        @MainOrgID   INT              = NULL,
        @SendSysID   INT              = NULL,
        @Guid        UNIQUEIDENTIFIER = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRANSACTION;

        INSERT INTO [Intesys].[OrderLine]
            (
                [OrderID],
                [SequenceNumber],
                [PatientID],
                [OriginalPatientID],
                [StatusCodeID],
                [TransportCodeID],
                [OrderLineComment],
                [clin_info_comment],
                [ReasonComment],
                [scheduledDateTime],
                [status_chgDateTime]
            )
        VALUES
            (
                @OrderID, 1, @PatientID, NULL, NULL, NULL, @Result_usid, NULL, NULL, NULL, NULL
            );

        INSERT INTO [Intesys].[Order]
            (
                [EncounterID],
                [OrderID],
                [PatientID],
                [OriginalPatientID],
                [PriorityCodeID],
                [StatusCodeID],
                [OrderPersonID],
                [OrderDateTime],
                [EnterID],
                [VerificationID],
                [TranscriberID],
                [ParentOrderID],
                [ChildOrderSwitch],
                [OrderControlCodeID],
                [HistorySwitch],
                [MonitorSwitch]
            )
        VALUES
            (
                @EncounterID, @OrderID, @PatientID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                CAST(0 AS BIT), NULL, CAST(0 AS BIT), CAST(1 AS BIT)
            );

        INSERT INTO [Intesys].[OrderMap]
            (
                [OrderID],
                [PatientID],
                [OriginalPatientID],
                [OrganizationID],
                [SystemID],
                [OrderXID],
                [TypeCode],
                [SequenceNumber]
            )
        VALUES
            (
                @OrderID, @PatientID, NULL, @MainOrgID, @SendSysID, @Guid, 'F', CAST(1 AS INT)
            );

        COMMIT TRANSACTION;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Add or Update Encounter Table values in DM3 Loader', @level0type = N'SCHEMA', @level0name = N'DM3', @level1type = N'PROCEDURE', @level1name = N'uspAddPatientOrder';

