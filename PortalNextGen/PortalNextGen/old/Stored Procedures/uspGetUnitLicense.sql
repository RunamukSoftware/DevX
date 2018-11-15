CREATE PROCEDURE [old].[uspGetUnitLicense]
    (
        @ProductCode      VARCHAR(25),
        @CategoryCode     CHAR(1),
        @OrganizationID   INT,
        @OrganizationCode NVARCHAR(40) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        IF (@OrganizationCode IS NOT NULL)
            BEGIN
                SELECT
                    [ORG].[OrganizationCode] AS [ORGCD]
                FROM
                    [Intesys].[Organization]      AS [ORG]
                    INNER JOIN
                        [Intesys].[ProductAccess] AS [PROACC]
                            ON [PROACC].[OrganizationID] = [ORG].[OrganizationID]
                WHERE
                    [PROACC].[ProductCode] = @ProductCode
                    AND [ORG].[CategoryCode] = @CategoryCode
                    AND (
                            [ORG].[OrganizationID] = @OrganizationID
                            AND [ORG].[OrganizationCode] = @OrganizationCode
                        );
            END;
        ELSE
            BEGIN
                SELECT
                    [ORG].[OrganizationCode] AS [ORGCD]
                FROM
                    [Intesys].[Organization]      AS [ORG]
                    INNER JOIN
                        [Intesys].[ProductAccess] AS [PROACC]
                            ON [PROACC].[OrganizationID] = [ORG].[OrganizationID]
                WHERE
                    [PROACC].[ProductCode] = @ProductCode
                    AND [ORG].[CategoryCode] = @CategoryCode
                    AND [ORG].[OrganizationID] = @OrganizationID;
            END;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Unit license by Unit Code Or Unit ID.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetUnitLicense';

