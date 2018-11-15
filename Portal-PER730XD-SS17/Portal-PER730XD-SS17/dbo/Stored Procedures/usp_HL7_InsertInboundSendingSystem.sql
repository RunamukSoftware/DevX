CREATE PROCEDURE [dbo].[usp_HL7_InsertInboundSendingSystem]
    (
     @SendingSystem NVARCHAR(180),
     @DynAddSendingSys BIT,
     @OrganizationId UNIQUEIDENTIFIER,
     @SendingSysId UNIQUEIDENTIFIER = NULL OUT
    )
AS
BEGIN
    SET @SendingSysId  = NULL;

    BEGIN TRY
        SET @SendingSysId = (SELECT
                                [sys_id]
                             FROM
                                [dbo].[int_send_sys]
                             WHERE
                                [code] = @SendingSystem
                                AND [organization_id] = @OrganizationId
                            );

        IF (@SendingSysId IS NULL
            AND @DynAddSendingSys = 1
            )
        BEGIN
            DECLARE @SendSysId UNIQUEIDENTIFIER = NEWID(); -- We will make this as constraint
            EXEC [dbo].[usp_InsertSendingSystemInformation] @SendSysId, @OrganizationId, @SendingSystem, NULL;
            SET @SendingSysId = @SendSysId; -- Need to change this to scope_identity
        END;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Use RAISERROR inside the CATCH block to return error
        -- information about the original error that caused
        -- execution to jump to the CATCH block.
        RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );
    END CATCH;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This procedure returns the SendingSystemId from the sending system table with organization id.  If it does not exist and Dynamically sending system is set to True, it will add the system system in the table.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_InsertInboundSendingSystem';

