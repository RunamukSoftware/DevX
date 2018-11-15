CREATE PROCEDURE [HL7].[uspGetUnitLicense]
    (
        @productcd      VARCHAR(25),
        @categoryCode   CHAR(1),
        @OrganizationID INT,
        @OrgCode        NVARCHAR(20) OUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SET @OrgCode =
            (
                SELECT
                        [ORG].[OrganizationCode]
                FROM
                        [Intesys].[Organization]  AS [ORG]
                    INNER JOIN
                        [Intesys].[ProductAccess] AS [PROACC]
                            ON [PROACC].[OrganizationID] = [ORG].[OrganizationID]
                WHERE
                        [PROACC].[ProductCode] = @productcd
                        AND [ORG].[CategoryCode] = @categoryCode
                        AND [ORG].[OrganizationID] = @OrganizationID
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Get Unit license by Unit Code Or Unit ID.', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspGetUnitLicense';

