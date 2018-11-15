CREATE FUNCTION [old].[ufnVitalMerge]
    (
        @InputStrings [old].[utpVitalValue] READONLY,
        @sDelim       VARCHAR(20)           = ' '
    )
RETURNS @retArray TABLE
    (
        [idx]   SMALLINT PRIMARY KEY,
        [value] VARCHAR(8000)
    )
WITH SCHEMABINDING
AS
    BEGIN
        DECLARE
            @VitalsCombine         VARCHAR(MAX) = '',
            @VitalsPatientRowCount INT          = 0;

        SELECT
            @VitalsPatientRowCount = COUNT([VitalValue])
        FROM
            @InputStrings;

        WHILE (@VitalsPatientRowCount > 0)
            BEGIN
                IF (@VitalsCombine <> '')
                    SET @VitalsCombine += @sDelim +
                                              (
                                                  SELECT
                                                      [VitalValue]
                                                  FROM
                                                      @InputStrings
                                                  WHERE
                                                      [VitalValueID] = @VitalsPatientRowCount
                                              );
                ELSE
                    SET @VitalsCombine =
                    (
                        SELECT
                            [VitalValue]
                        FROM
                            @InputStrings
                        WHERE
                            [VitalValueID] = @VitalsPatientRowCount
                    );

                SET @VitalsPatientRowCount -= 1;
            END;

        INSERT INTO @retArray
            (
                [idx],
                [value]
            )
                    SELECT
                        [idx],
                        [value]
                    FROM
                        [old].[ufnSplit](@VitalsCombine, @sDelim);

        RETURN;
    END;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Merge vital values into a single string.', @level0type = N'SCHEMA', @level0name = N'old', @level1type = N'FUNCTION', @level1name = N'ufnVitalMerge';

