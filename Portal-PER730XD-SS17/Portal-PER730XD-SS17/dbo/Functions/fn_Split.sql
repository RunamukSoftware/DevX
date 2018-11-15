CREATE FUNCTION [dbo].[fn_Split]
    (@sText VARCHAR(8000),
     @sDelim VARCHAR(20) = ' ')
RETURNS @retArray TABLE
    ([idx] SMALLINT NOT NULL PRIMARY KEY,
     [value] VARCHAR(8000))
WITH SCHEMABINDING
AS
BEGIN
    DECLARE
        @idx SMALLINT = 0,
        @value VARCHAR(8000),
        @bcontinue BIT = 1,
        @iStrike SMALLINT,
        @iDelimlength TINYINT;

    IF (@sDelim = 'Space')
    BEGIN
        SET @sDelim = ' ';
    END;

    SET @sText = LTRIM(RTRIM(@sText));
    SET @iDelimlength = DATALENGTH(@sDelim);

    IF NOT (@iDelimlength = 0
            OR @sDelim = 'Empty')
    BEGIN
        WHILE (@bcontinue = 1)
        BEGIN
            -- If you can find the delimiter in the text, retrieve the first element and
            -- insert it with its index into the return table.
            IF (CHARINDEX(@sDelim, @sText) > 0)
            BEGIN
                SET @value = SUBSTRING(@sText, 1, CHARINDEX(@sDelim, @sText) - 1);
                BEGIN
                    INSERT @retArray ([idx],
                                      [value])
                    VALUES (
                           @idx, @value
                           );
                END;

                -- Trim the element and its delimiter from the front of the string.
                -- Increment the index and loop.
                SET @iStrike = DATALENGTH(@value) + @iDelimlength;
                SET @idx = @idx + 1;
                SET @sText = LTRIM(RIGHT(@sText, DATALENGTH(@sText) - @iStrike));
            END;
            ELSE
            BEGIN
                -- If you can't find the delimiter in the text, @sText is the last value in @retArray.
                SET @value = @sText;
                BEGIN
                    INSERT @retArray ([idx],
                                      [value])
                    VALUES (
                           @idx, @value
                           );
                END;

                -- Exit the WHILE loop.
                SET @bcontinue = 0;
            END;
        END;
    END;
    ELSE
    BEGIN
        WHILE (@bcontinue = 1)
        BEGIN
            -- If the delimiter is an empty string, check for remaining text
            -- instead of a delimiter. Insert the first character into the
            -- retArray table. Trim the character from the front of the string.
            -- Increment the index and loop.
            IF (DATALENGTH(@sText) > 1)
            BEGIN
                SET @value = SUBSTRING(@sText, 1, 1);
                BEGIN
                    INSERT @retArray ([idx],
                                      [value])
                    VALUES (
                           @idx, @value
                           );
                END;

                SET @idx += 1;
                SET @sText = SUBSTRING(@sText, 2, DATALENGTH(@sText) - 1);
            END;
            ELSE
            BEGIN
                -- One character remains.
                -- Insert the character and exit the WHILE loop.
                INSERT @retArray ([idx],
                                  [value])
                VALUES (
                       @idx, @sText
                       );

                SET @bcontinue = 0;
            END;
        END;
    END;

    RETURN;
END;
GO
EXECUTE [sys].[sp_addextendedproperty]
    @name = N'MS_Description',
    @value = N'Split a text string using the delimiter into multiple rows',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'FUNCTION',
    @level1name = N'fn_Split';
