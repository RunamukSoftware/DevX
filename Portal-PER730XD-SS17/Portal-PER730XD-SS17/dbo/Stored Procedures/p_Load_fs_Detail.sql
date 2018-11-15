CREATE PROCEDURE [dbo].[p_Load_fs_Detail]
    (
     @flowsheetID UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [int_flowsheet_detail].[flowsheet_detail_id],
        [int_flowsheet_detail].[flowsheet_id],
        [int_flowsheet_detail].[name],
        [int_flowsheet_detail].[detail_type],
        [int_flowsheet_detail].[parent_id],
        [int_flowsheet_detail].[seq],
        [int_flowsheet_detail].[test_cid],
        [int_flowsheet_detail].[show_only_when_data],
        [int_flowsheet_detail].[is_compressed],
        [int_flowsheet_detail].[is_visible],
        [int_flowsheet_detail].[flowsheet_entry_id],
        [int_flowsheet_entry].[flowsheet_entry_id],
        [int_flowsheet_entry].[test_cid],
        [int_flowsheet_entry].[data_type],
        [int_flowsheet_entry].[select_list_id],
        [int_flowsheet_entry].[units],
        [int_flowsheet_entry].[normal_float],
        [int_flowsheet_entry].[absolute_float_high],
        [int_flowsheet_entry].[absolute_float_low],
        [int_flowsheet_entry].[warning_float_high],
        [int_flowsheet_entry].[warning_float_low],
        [int_flowsheet_entry].[critical_float_high],
        [int_flowsheet_entry].[critical_float_low],
        [int_flowsheet_entry].[normal_int],
        [int_flowsheet_entry].[absolute_int_high],
        [int_flowsheet_entry].[absolute_int_low],
        [int_flowsheet_entry].[warning_int_high],
        [int_flowsheet_entry].[warning_int_low],
        [int_flowsheet_entry].[critical_int_high],
        [int_flowsheet_entry].[critical_int_low],
        [int_flowsheet_entry].[normal_string],
        [int_flowsheet_entry].[max_length],
        [int_misc_code].[code],
        [int_misc_code].[short_dsc]
    FROM
        [dbo].[int_flowsheet_detail]
        LEFT OUTER JOIN [dbo].[int_flowsheet_entry] ON [int_flowsheet_detail].[flowsheet_entry_id] = [int_flowsheet_entry].[flowsheet_entry_id]
        LEFT OUTER JOIN [dbo].[int_misc_code] ON [int_flowsheet_detail].[test_cid] = [int_misc_code].[code_id]
    WHERE
        [flowsheet_id] = @flowsheetID
    ORDER BY
        [parent_id],
        [seq];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Load_fs_Detail';

