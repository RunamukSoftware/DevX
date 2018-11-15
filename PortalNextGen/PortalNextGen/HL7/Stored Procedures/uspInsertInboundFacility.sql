CREATE PROCEDURE [HL7].[uspInsertInboundFacility]
    (
        @SendingFacility NVARCHAR(180),
        @DynAddOrgs      BIT,
        @FacilityID      INT OUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SET @FacilityID = NULL;

        DECLARE
            @PrimaryOrganization INT,
            @OrganizationID      INT;

        BEGIN TRY
            SELECT
                @FacilityID = [io].[OrganizationID]
            FROM
                [Intesys].[Organization] AS [io]
            WHERE
                [io].[CategoryCode] = 'F'
                AND [io].[OrganizationCode] = @SendingFacility;

            IF (
                   @FacilityID IS NULL
                   AND @DynAddOrgs = 1
               )
                BEGIN
                    SELECT
                        @PrimaryOrganization = [io].[OrganizationID]
                    FROM
                        [Intesys].[Organization] AS [io]
                    WHERE
                        [io].[CategoryCode] = 'O';

                    EXEC [old].[uspInsertOrganizationInformation]
                        @OrganizationID = @OrganizationID,
                        @CategoryCode = 'F',
                        @ParentOrganizationID = @PrimaryOrganization,
                        @OrganizationCode = @SendingFacility,
                        @OrganizationName = @SendingFacility;

                    SET @FacilityID = @OrganizationID;
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This procedure returns the OrganizationID, if the sending facility exists in the category code ''F''.  If not exists and Dynamically Add Organizations is set to True, it will add the organization in the table.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspInsertInboundFacility';

