/****** Object:  StoredProcedure [dbo].[GetHTMLSafeToken]    Script Date: 2021-07-20 2:07:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetHTMLSafeToken] @length int, @token varchar(255) OUTPUT

as

-- set alphabet string ex. 0123456789abcd
	-- strings of length power of two will allow for even distribution between tokens (2,4,8,16,32,64,128,256)

-- for each character in random string (for i=0 to desired_string_length)
--	get random bytes (longer length is better if alphabet is not a power of 2 in length)
--	character = random_bytes[index] % alphabet_length
--	add character to string

BEGIN

DECLARE @alphabet varchar(max)
SET @alphabet = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_' -- 64 character length

DECLARE @random_bytes varbinary(max)

-- get a byte for every character in the string	(since 64 fits into 255)
	-- if >255 we would need at least 2 bytes for every output
SET @random_bytes=crypt_gen_random(@length)

DECLARE @counter int, @next_byte int
DECLARE @r varchar(max)

SET @counter = 1
WHILE @counter < @length + 1
BEGIN

	SELECT @next_byte = SUBSTRING(@random_bytes, @counter, 1)
	SELECT @r = COALESCE(@r, '') + CAST(SUBSTRING(@alphabet, (@next_byte % 64)+1, 1) as varchar(1))

	SELECT @counter = @counter + 1

END

SET @token = @r

END


GRANT EXECUTE ON [dbo].[GetHTMLSafeToken] TO [DeskFlowUsers]

GO
/****** Object:  StoredProcedure [dbo].[GetTimeSheetsCode]    Script Date: 2021-07-22 ******/

CREATE PROCEDURE [dbo].[GetTimeSheetsCode] @peopleid int, @codetype int, @expiry datetime, @retVal varchar(255) OUTPUT

as

BEGIN

	DECLARE @code varchar(max),
			@counter int

	SET @retVal = ''
	SET @counter = 0

	-- Loop until we have a code that does not exist in the table
	WHILE(@counter < 100)
	BEGIN

		EXECUTE dbo.[GetHTMLSafeToken] 20, @code OUTPUT

		IF NOT EXISTS( SELECT TimeSheetsCodesID FROM TimeSheetsCodes WITH(NOLOCK) WHERE Code = @code)
		BEGIN
			BREAK;
		END

		SET @counter = @counter + 1
	END

	IF( @code IS NOT NULL )
	BEGIN

		INSERT INTO TimeSheetsCodes (PeopleID, Code, CodeType, CodeExpiry)
		VALUES( @peopleid, @code, @codetype, @expiry)

		SELECT @retVal = @code
		/*
		TimeSheetsCodesID
		FROM TimeSheetsCodes WITH(NOLOCK)
		WHERE Code = @code
		*/

	END

END
GRANT EXECUTE ON [dbo].[GetTimeSheetsCode] TO [DeskFlowUsers]