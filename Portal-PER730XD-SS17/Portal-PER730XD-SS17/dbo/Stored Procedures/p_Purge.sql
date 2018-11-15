CREATE PROCEDURE [dbo].[p_Purge] (@mrn CHAR(30))
AS
BEGIN
    DECLARE
        @pat_id UNIQUEIDENTIFIER,
        @msg VARCHAR(120);

    SELECT
        @pat_id = [patient_id]
    FROM
        [dbo].[int_mrn_map]
    WHERE
        [mrn_xid] = @mrn;

    IF (@pat_id IS NULL)
        SELECT
            'patient not found..';
    ELSE
    BEGIN
        SET @msg = 'Purging patient: MRN=' + @mrn;
        SET @msg += ' patient_id = ';
        SET @msg += CAST(@pat_id AS VARCHAR(45));

        SELECT
            @msg;

        DELETE
            [ip]
        FROM
            [dbo].[int_patient] AS [ip]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [ipn]
        FROM
            [dbo].[int_person_name] AS [ipn]
        WHERE
            [person_nm_id] = @pat_id;

        DELETE
            [ip]
        FROM
            [dbo].[int_person] AS [ip]
        WHERE
            [person_id] = @pat_id;

        DELETE
            [ie]
        FROM
            [dbo].[int_encounter] AS [ie]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [ir]
        FROM
            [dbo].[int_result] AS [ir]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [imm]
        FROM
            [dbo].[int_mrn_map] AS [imm]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [iem]
        FROM
            [dbo].[int_encounter_map] AS [iem]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [iom]
        FROM
            [dbo].[int_order_map] AS [iom]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [iol]
        FROM
            [dbo].[int_order_line] AS [iol]
        WHERE
            [patient_id] = @pat_id;

        DELETE
            [io]
        FROM
            [dbo].[int_order] AS [io]
        WHERE
            [patient_id] = @pat_id;
    END;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Purge';

