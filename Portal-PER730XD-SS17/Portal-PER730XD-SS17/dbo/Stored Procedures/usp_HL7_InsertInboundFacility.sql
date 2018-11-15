CREATE PROCEDURE [dbo].[usp_HL7_InsertInboundFacility]
    (
     @SendingFacility NVARCHAR(180),
     @DynAddOrgs BIT,
     @FacilityId UNIQUEIDENTIFIER = NULL OUT
    )
AS
BEGIN
    SET @FacilityId = NULL;

    BEGIN TRY
        SET @FacilityId = (SELECT
                            [organization_id]
                           FROM
                            [dbo].[int_organization]
                           WHERE
                            [category_cd] = 'F'
                            AND [organization_cd] = @SendingFacility
                          );
        IF (@FacilityId IS NULL
            AND @DynAddOrgs = 1
            )
        BEGIN
            DECLARE
                @PrimaryOrganization UNIQUEIDENTIFIER,
                @orgId UNIQUEIDENTIFIER = NEWID(); --we will make this as constraint
            SET @PrimaryOrganization = (SELECT
                                            [organization_id]
                                        FROM
                                            [dbo].[int_organization]
                                        WHERE
                                            [category_cd] = 'O'
                                       );

            EXEC [dbo].[usp_InsertOrganizationInformation] @organizationId = @orgId, @categoryCd = 'F', @parentOrganizationId = @PrimaryOrganization, @organizationCd = @SendingFacility, @organizationNm = @SendingFacility;
            SET @FacilityId = @orgId;
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This procedure returns the organization_id, if the sending facility exists in the category code ''F''.  If not exists and Dynamically Add Organizations is set to True, it will add the organization in the table.
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_HL7_InsertInboundFacility';

