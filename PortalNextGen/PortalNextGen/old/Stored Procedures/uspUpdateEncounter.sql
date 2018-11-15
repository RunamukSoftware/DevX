CREATE PROCEDURE [old].[uspUpdateEncounter]
    (
        @UnitOrganizationID INT,
        @OrganizationID     INT,
        @Room               NVARCHAR(6),
        @Bed                NVARCHAR(6),
        @PatientID          INT
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[Encounter]
        SET
            [UnitOrganizationID] = @UnitOrganizationID,
            [OrganizationID] = @OrganizationID,
            [Room] = @Room,
            [Bed] = @Bed
        WHERE
            [StatusCode] = N'C'
            AND [PatientID] = @PatientID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'PROCEDURE', @level1name = N'uspUpdateEncounter';

