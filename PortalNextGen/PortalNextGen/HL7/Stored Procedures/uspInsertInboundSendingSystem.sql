CREATE PROCEDURE [HL7].[uspInsertInboundSendingSystem]
    (
        @SendingSystem    NVARCHAR(180),
        @DynAddSendingSys BIT,
        @OrganizationID   INT,
        @SendingSystemID  INT OUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @SendSysID INT = 0; --NEWID(); -- We will make this as constraint

        SET @SendingSystemID = NULL;

        BEGIN TRY
            SET @SendingSystemID =
                (
                    SELECT
                        [iss].[SystemID]
                    FROM
                        [Intesys].[SendSystem] AS [iss]
                    WHERE
                        [iss].[Code] = @SendingSystem
                        AND [iss].[OrganizationID] = @OrganizationID
                );

            IF (
                   @SendingSystemID IS NULL
                   AND @DynAddSendingSys = 1
               )
                BEGIN
                    EXEC [old].[uspInsertSendingSystemInformation]
                        @SendSysID,
                        @OrganizationID,
                        @SendingSystem,
                        NULL;

                    SET @SendingSystemID = @SendSysID; -- Need to change this to SCOPE_IDENTITY
                END;
        END TRY
        BEGIN CATCH
            DECLARE @ErrorMessage NVARCHAR(4000);
            DECLARE @ErrorSeverity INT;
            DECLARE @ErrorState INT;

            SELECT
                @ErrorMessage  = ERROR_MESSAGE(),
                @ErrorSeverity = ERROR_SEVERITY(),
                @ErrorState    = ERROR_STATE();

            -- Use RAISERROR inside the CATCH block to return error
            -- information about the original error that caused
            -- execution to jump to the CATCH block.
            RAISERROR(   @ErrorMessage,  -- Message text.
                         @ErrorSeverity, -- Severity.
                         @ErrorState     -- State.
                     );
        END CATCH;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This procedure returns the SendingSystemID from the sending system table with organization id.  If it does not exist and Dynamically sending system is set to True, it will add the system system in the table.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspInsertInboundSendingSystem';

