CREATE PROCEDURE [dbo].[p_enc_det_drs]
    (
     @enc_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    DECLARE
        @att_hcp_id UNIQUEIDENTIFIER,
        @ref_hcp_id UNIQUEIDENTIFIER,
        @adm_hcp_id UNIQUEIDENTIFIER;

    CREATE TABLE [#ENC_DET_DRS]
        (
         [hcp_id] UNIQUEIDENTIFIER,
         [priority] INT,
         [lastname] VARCHAR(50) NULL,
         [firstname] VARCHAR(50) NULL,
         [middlename] VARCHAR(50) NULL,
         [role_cd] CHAR(1)
        );

    SELECT
        @att_hcp_id = [attend_hcp_id],
        @ref_hcp_id = [referring_hcp_id],
        @adm_hcp_id = [admit_hcp_id]
    FROM
        [dbo].[int_encounter]
    WHERE
        [encounter_id] = @enc_id;

    -- Attending
    IF (@att_hcp_id IS NOT NULL)
    BEGIN
        INSERT  INTO [#ENC_DET_DRS]
        SELECT
            @att_hcp_id,
            1,
            CAST([H].[last_nm] AS VARCHAR(50)),
            CAST([H].[first_nm] AS VARCHAR(50)),
            CAST([H].[middle_nm] AS VARCHAR(50)),
            'T'
        FROM
            [dbo].[int_hcp] AS [H]
        WHERE
            [H].[hcp_id] = @att_hcp_id;
    END;

    -- Admitting
    IF (@adm_hcp_id IS NOT NULL)
    BEGIN
        INSERT  INTO [#ENC_DET_DRS]
        SELECT
            @adm_hcp_id,
            1,
            CAST([H].[last_nm] AS VARCHAR(50)),
            CAST([H].[first_nm] AS VARCHAR(50)),
            CAST([H].[middle_nm] AS VARCHAR(50)),
            'A'
        FROM
            [dbo].[int_hcp] AS [H]
        WHERE
            [H].[hcp_id] = @adm_hcp_id;
    END;

  -- Referring
    IF (@ref_hcp_id IS NOT NULL)
    BEGIN
        INSERT  INTO [#ENC_DET_DRS]
        SELECT
            @ref_hcp_id,
            2,
            CAST([H].[last_nm] AS VARCHAR(50)),
            CAST([H].[first_nm] AS VARCHAR(50)),
            CAST([H].[middle_nm] AS VARCHAR(50)),
            'R'
        FROM
            [dbo].[int_hcp] AS [H]
        WHERE
            [H].[hcp_id] = @ref_hcp_id;
    END;

    -- Consulting docs
    INSERT  INTO [#ENC_DET_DRS]
    SELECT DISTINCT
        ([E].[hcp_id]),
        3,
        CAST([H].[last_nm] AS VARCHAR(50)),
        CAST([H].[first_nm] AS VARCHAR(50)),
        CAST([H].[middle_nm] AS VARCHAR(50)),
        CAST([E].[hcp_role_cd] AS CHAR(1))
    FROM
        [dbo].[int_encounter_to_hcp_int] AS [E]
        INNER JOIN [dbo].[int_hcp] AS [H] ON [E].[hcp_id] = [H].[hcp_id]
    WHERE
        [E].[hcp_role_cd] = N'C'
        AND [E].[encounter_id] = @enc_id;

    -- Select out data
    SELECT
        [role_cd],
        [lastname],
        [firstname],
        [middlename]
    FROM
        [#ENC_DET_DRS]
    ORDER BY
        [priority],
        [lastname];

    DROP TABLE [#ENC_DET_DRS];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_enc_det_drs';

