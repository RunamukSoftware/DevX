CREATE PROCEDURE [old].[uspGetCodeByCategoryCode]
    (
        @CategoryCode    CHAR(4),
        @MethodCode      NVARCHAR(10),
        @Code            NVARCHAR(80),
        @OrganizationID  INT,
        @SendingSystemID INT,
        @CodeID          INT OUT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        SET @CodeID =
            (
                SELECT
                    [MiscCode].[CodeID]
                FROM
                    [Intesys].[MiscellaneousCode] AS [MiscCode]
                    INNER JOIN
                        [Intesys].[CodeCategory]  AS [CodeCat]
                            ON [MiscCode].[CategoryCode] = [CodeCat].[CategoryCode]
                WHERE
                    [MiscCode].[CategoryCode] = @CategoryCode
                    AND [MiscCode].[Code] = @Code
                    AND [MiscCode].[OrganizationID] = @OrganizationID
                    AND [MiscCode].[SystemID] = @SendingSystemID
                    AND [MiscCode].[MethodCode] = @MethodCode
            );
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gets code id by category code.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspGetCodeByCategoryCode';

