CREATE PROCEDURE [dbo].[usp_UpdatePerson]
    (
     @last_nm NVARCHAR(50),
     @first_nm NVARCHAR(50),
     @middle_nm NVARCHAR(50),
     @person_id UNIQUEIDENTIFIER
    )
AS
BEGIN
    UPDATE
        [dbo].[int_person]
    SET
        [last_nm] = @last_nm,
        [first_nm] = @first_nm,
        [middle_nm] = @middle_nm
    WHERE
        [person_id] = @person_id;
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_UpdatePerson';

