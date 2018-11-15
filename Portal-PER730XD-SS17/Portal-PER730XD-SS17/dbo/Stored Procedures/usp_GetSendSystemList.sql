CREATE PROCEDURE [dbo].[usp_GetSendSystemList]
    (
     @organization_id NVARCHAR(MAX) = NULL
    )
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX) = N'
        SELECT 
            code,
            dsc,
            sys_id 
        FROM 
            dbo.int_send_sys '; 
                                                       
    DECLARE @Query1 NVARCHAR(MAX) = N' ORDER BY code';
    
    IF (LEN(@organization_id) > 0)
    BEGIN
        SET @Query += N' WHERE organization_id = ';
        SET @Query += N'''' + @organization_id + N'''';
        SET @Query += @Query1;
    END;                                                    
    ELSE
    BEGIN
        SET @Query += @Query1;    
    END;                                                                

    EXEC(@Query);
END;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_GetSendSystemList';

