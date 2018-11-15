CREATE PROCEDURE [dbo].[p_Nok]
    (
     @patient_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    SELECT
        [N].[patient_id],
        [N].[notify_seq_no] AS [priority],
        [N].[relationship_cid],
        [A].[line1_dsc] AS [ADDR1],
        [A].[line2_dsc] AS [ADDR2],
        [A].[line3_dsc] AS [ADDR3],
        [A].[city_nm] AS [CITY],
        [A].[state_code] AS [STATE],
        [A].[zip_code] AS [ZIPCODE],
        [A].[country_cid],
        [P].[last_nm] AS [LASTNAME],
        [P].[first_nm] AS [FIRSTNAME],
        [P].[middle_nm] AS [MIDDLENAME],
        [T1].[tel_no] + [T1].[ext_no] AS [HOME_PHONE],
        [T2].[tel_no] + [T2].[ext_no] AS [BUSINESS_PHONE]
    FROM
        [dbo].[int_nok] AS [N]
        INNER JOIN [dbo].[int_person_name] AS [P] ON [P].[person_nm_id] = [N].[nok_person_id]
        RIGHT OUTER JOIN [dbo].[int_address] AS [A] ON [N].[nok_person_id] = [A].[address_id]
        RIGHT OUTER JOIN [dbo].[int_telephone] AS [T1] ON [N].[nok_person_id] = [T1].[phone_id]
        RIGHT OUTER JOIN [dbo].[int_telephone] AS [T2] ON [N].[nok_person_id] = [T2].[phone_id]
    WHERE
        [P].[recognize_nm_cd] = 'P'
        AND [N].[active_flag] = 1
        AND [N].[patient_id] = @patient_id
        AND [T1].[phone_loc_cd] = 'R'
        AND [T1].[phone_type_cd] = 'V'
        AND [T1].[seq_no] = (SELECT
                                MIN([seq_no])
                             FROM
                                [dbo].[int_telephone]
                             WHERE
                                [phone_loc_cd] = 'R'
                                AND [phone_id] = [N].[nok_person_id]
                                AND [phone_type_cd] = 'V'
                            )
        AND [T2].[phone_loc_cd] = 'B'
        AND [T2].[phone_type_cd] = 'V'
        AND [T2].[seq_no] = (SELECT
                                MIN([seq_no])
                             FROM
                                [dbo].[int_telephone]
                             WHERE
                                [phone_loc_cd] = 'B'
                                AND [phone_id] = [N].[nok_person_id]
                                AND [phone_type_cd] = 'V'
                            )
    ORDER BY
        [priority];
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'p_Nok';

