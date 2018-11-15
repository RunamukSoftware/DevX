CREATE PROCEDURE [HL7].[uspUpdateHealthCareProviderInformation]
    (
        @HealthCareProviderID INT,
        @LastName             NVARCHAR(50) = NULL,
        @FirstName            NVARCHAR(50) = NULL,
        @MiddleName           NVARCHAR(50) = NULL,
        @Degree               NVARCHAR(20) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE
            [Intesys].[HealthCareProvider]
        SET
            [LastName] = @LastName,
            [FirstName] = @FirstName,
            [MiddleName] = @MiddleName,
            [degree] = @Degree
        WHERE
            [HealthCareProviderID] = @HealthCareProviderID;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'HL7', @level1type = N'PROCEDURE', @level1name = N'uspUpdateHealthCareProviderInformation';

