-- If AllowRank is set we need to map existing answer types to new values

IF ( SELECT IsNull(AllowRankWebApps,0) FROM ClientConfig ) = 1
BEGIN

	-- Memo 4 ----> 5
	UPDATE Questions SET AnswerTypeID = 5
	WHERE AnswerTypeID = 4


	-- Single Line Text 3 ----> 4
	UPDATE Questions SET AnswerTypeID = 4
	WHERE AnswerTypeID = 3


	-- Multiple Choice 2 ----> 6
	UPDATE Questions SET AnswerTypeID = 6
	WHERE AnswerTypeID = 2


	-- Single Choice 1 ---> 7
	UPDATE Questions SET AnswerTypeID = 7
	WHERE AnswerTypeID = 1

END