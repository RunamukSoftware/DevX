CREATE PROCEDURE [old].[uspGetProductAccess]
    (
        @ProductCode AS VARCHAR(25),
        @UnitID AS    INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [P].[HasAccess]
        FROM
            [Intesys].[Product]           AS [P]
            INNER JOIN
                [Intesys].[ProductAccess] AS [PA]
                    ON [P].[ProductCode] = [PA].[ProductCode]
            INNER JOIN
                [Intesys].[Organization]  AS [O]
                    ON [PA].[OrganizationID] = [O].[OrganizationID]
        WHERE
            [PA].[ProductCode] = @ProductCode
            AND [O].[CategoryCode] = 'D'
            AND [O].[OrganizationID] = @UnitID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetProductAccess';

