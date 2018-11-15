CREATE PROCEDURE [dbo].[Fix_FlowSheet_Detail]
AS
BEGIN
    DECLARE
        @detail_id UNIQUEIDENTIFIER,
        @org_id UNIQUEIDENTIFIER,
        @sys_id UNIQUEIDENTIFIER,
        @name VARCHAR(60),
        @test_cid INT,
        @code_id INT,
        --@cnt INT,
        @code VARCHAR(20);
    SELECT
        @sys_id = [sys_id],
        @org_id = [organization_id]
    FROM
        [dbo].[int_send_sys]
    WHERE
        [code] = N'GTWY';

    DECLARE [TCURSOR] CURSOR FAST_FORWARD
    FOR
    SELECT
        [flowsheet_detail_id],
        [name],
        [test_cid]
    FROM
        [dbo].[int_flowsheet_detail]
    WHERE
        [detail_type] = N'fdtSub';

    OPEN [TCURSOR];

    FETCH NEXT FROM [TCURSOR] INTO @detail_id, @name, @test_cid;

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SELECT
            @detail_id,
            @name,
            @test_cid;

        /*
        SELECT
            @code_id = [code_id]
        FROM
            [dbo].[int_misc_code]
        WHERE
            [code] = @name
            AND [category_cd] = 'ATST'
            AND [method_cd] = N'GDS';
      
        SELECT
            @cnt = COUNT(*)
        FROM
            [dbo].[int_misc_code]
        WHERE
            [code] = @name
            AND [category_cd] = 'ATST'
            AND [method_cd] = N'GDS';
      
        IF (@cnt = 0)
        BEGIN 
            SELECT
                @code_id = MAX([code_id]) + 1
            FROM
                [dbo].[int_misc_code];

            INSERT  INTO [dbo].[int_misc_code]
                    ([code_id],
                     [organization_id],
                     [sys_id],
                     [category_cd],
                     [method_cd],
                     [code],
                     [verification_sw],
                     [int_keystone_cd],
                     [short_dsc]
                    )
            VALUES
                    (@code_id,
                     @org_id,
                     @sys_id,
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
            @code_id = MAX([code_id]) + 1
        FROM
            [dbo].[int_misc_code];
        SELECT
            @code = CONVERT(VARCHAR(20), @code_id);

        INSERT  INTO [dbo].[int_misc_code]
                ([code_id],
                 [organization_id],
                 [sys_id],
                 [category_cd],
                 [method_cd],
                 [code],
                 [verification_sw],
                 [int_keystone_cd],
                 [short_dsc]
                )
        VALUES
                (@code_id,
                 @org_id,
                 @sys_id,
                 'ATST',
                 N'GDS',
                 @code,
                 NULL,
                 @name,
                 @name
                );

        UPDATE
            [dbo].[int_flowsheet_detail]
        SET
            [test_cid] = @code_id
        WHERE
            [flowsheet_detail_id] = @detail_id;

        FETCH NEXT FROM [TCURSOR] 
        INTO @detail_id, @name, @test_cid;
    END;

    CLOSE [TCURSOR];

    DEALLOCATE [TCURSOR];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fix flowsheet_detail rows the sub test test_code id from cmplus points to its parent''s test code had to generate new ones', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'Fix_FlowSheet_Detail';

