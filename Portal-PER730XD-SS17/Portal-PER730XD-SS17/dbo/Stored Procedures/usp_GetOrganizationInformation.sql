CREATE PROCEDURE [dbo].[usp_GetOrganizationInformation]
    (
     @organizationCd NVARCHAR(40) = NULL,
     @categoryCd CHAR = NULL
    )
AS
BEGIN
    SET NOCOUNT ON;

    IF (@organizationCd IS NOT NULL
        AND @categoryCd IS NOT NULL
        )
    BEGIN
        SELECT
            [organization_id],
            [category_cd],
            [parent_organization_id],
            [organization_cd],
            [organization_nm],
            [in_default_search],
            [monitor_disable_sw],
            [auto_collect_interval],
            [outbound_interval],
            [printer_name],
            [alarm_printer_name]
        FROM
            [dbo].[int_organization]
        WHERE
            [category_cd] = @categoryCd
            AND [organization_cd] = @organizationCd;
    END;
    ELSE
        IF (@categoryCd IS NOT NULL)
        BEGIN
            SELECT
                [organization_id],
                [category_cd],
                [parent_organization_id],
                [organization_cd],
                [organization_nm],
                [in_default_search],
                [monitor_disable_sw],
                [auto_collect_interval],
                [outbound_interval],
                [printer_name],
                [alarm_printer_name]
            FROM
                [dbo].[int_organization]
            WHERE
                [category_cd] = @categoryCd;
        END;    
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fetch the organization details based on the Organization code or Category Code.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetOrganizationInformation';

