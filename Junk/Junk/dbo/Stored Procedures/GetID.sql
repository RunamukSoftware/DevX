CREATE PROCEDURE [dbo].[GetID]
    @ID INT OUTPUT,
    @ATM_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [ATM]
    SET
        [LastTransaction_ID] = @ID + 1,
        @ID = [LastTransaction_ID]
    WHERE [ATM_ID] = @ATM_ID;
END;
