CREATE PROCEDURE [Archive].[uspFixFlowSheetDetail]
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @DetailID       INT,
            @OrganizationID INT,
            @SystemID       INT,
            @Name           VARCHAR(60),
            @TestCodeID     INT,
            @CodeID         INT,
            --@cnt INT,
            @code           VARCHAR(20);
        SELECT
            @SystemID       = [ss].[SystemID],
            @OrganizationID = [ss].[OrganizationID]
        FROM
            [Intesys].[SendSystem] AS [ss]
        WHERE
            [ss].[Code] = N'GTWY';

        DECLARE [TCURSOR] CURSOR FAST_FORWARD LOCAL READ_ONLY FOR
            SELECT
                [ifd].[FlowsheetDetailID],
                [ifd].[Name],
                [ifd].[TestCodeID]
            FROM
                [Archive].[FlowsheetDetail] AS [ifd]
            WHERE
                [ifd].[DetailType] = N'fdtSub';

        OPEN [TCURSOR];

        FETCH NEXT FROM [TCURSOR]
        INTO
            @DetailID,
            @Name,
            @TestCodeID;

        WHILE (@@FETCH_STATUS = 0)
            BEGIN
                SELECT
                    @DetailID,
                    @Name,
                    @TestCodeID;

                /*
        SELECT
            @CodeID = [CodeID]
        FROM
            [Intesys].[misc_code]
        WHERE
            [code] = @name
            AND [CategoryCode] = 'ATST'
            AND [MethodCode] = N'GDS';
      
        SELECT
            @cnt = COUNT(*)
        FROM
            [Intesys].[misc_code]
        WHERE
            [code] = @name
            AND [CategoryCode] = 'ATST'
            AND [MethodCode] = N'GDS';
      
        IF (@cnt = 0)
        BEGIN 
            SELECT
                @CodeID = MAX([CodeID]) + 1
            FROM
                [Intesys].[misc_code];

            INSERT  INTO [Intesys].[misc_code]
                    ([CodeID],
                     [OrganizationID],
                     [SystemID],
                     [CategoryCode],
                     [MethodCode],
                     [code],
                     [VerificationSwitch],
                     [KeystoneCode],
                     [ShortDescription]
                    )
            VALUES
                    (@CodeID,
                     @OrganizationID,
                     @SystemID,
                     'ATST',
                     N'GDS',
                     @name,
                     NULL,
                     @name,
                     @name
                    );
        END;
        */

                SELECT
                    @CodeID = MAX([imc].[CodeID]) + 1
                FROM
                    [Intesys].[MiscellaneousCode] AS [imc];
                SELECT
                    @code = CONVERT(VARCHAR(20), @CodeID);

                INSERT INTO [Intesys].[MiscellaneousCode]
                    (
                        [CodeID],
                        [OrganizationID],
                        [SystemID],
                        [CategoryCode],
                        [MethodCode],
                        [Code],
                        [VerificationSwitch],
                        [KeystoneCode],
                        [ShortDescription]
                    )
                VALUES
                    (
                        @CodeID, @OrganizationID, @SystemID, 'ATST', N'GDS', @code, NULL, @Name, @Name
                    );

                UPDATE
                    [Archive].[FlowsheetDetail]
                SET
                    [TestCodeID] = @CodeID
                WHERE
                    [FlowsheetDetailID] = @DetailID;

                FETCH NEXT FROM [TCURSOR]
                INTO
                    @DetailID,
                    @Name,
                    @TestCodeID;
            END;

        CLOSE [TCURSOR];

        DEALLOCATE [TCURSOR];
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fix flowsheet_detail rows the sub test test_code id from cmplus points to its parent''s test code had to generate new ones', @level0type = N'SCHEMA', @level0name = N'Archive', @level1type = N'PROCEDURE', @level1name = N'uspFixFlowSheetDetail';

