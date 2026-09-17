ALTER TABLE People add ManualBlockUntilDate datetime
GO
CREATE FUNCTION  [dbo].[fn_GetPersonBlockNew] ( @CurProjectsID int,@CandBlockStatus int, @CandBlockProjectsID int, @ClientTeamBlockStatus int, 
                                             @ClientTeamBlockUntilDate datetime,@PlacedBlockStatus int,@PlacedBlockUntilDate datetime,
                                             @ManualBlockUntilDate datetime )
RETURNS varchar(50)
AS
BEGIN
DECLARE @Ret varchar(50)
set @Ret= '0-Not Blocked'
if (( @CandBlockStatus = 1 and @CandBlockProjectsID > 0 and ISNULL(@CandBlockProjectsID,0)<>@CurProjectsID))
OR ( @CandBlockStatus = 1 and ISNULL(@CandBlockProjectsID,0)=0 and @ManualBlockUntilDate is not null and @ManualBlockUntilDate >GETDATE())
OR ( @PlacedBlockStatus = 1 and @PlacedBlockUntilDate is not null and @PlacedBlockUntilDate >GETDATE()) 
OR ( @ClientTeamBlockStatus = 1 and @ClientTeamBlockUntilDate is not null and @ClientTeamBlockUntilDate>GETDATE())
	set @Ret = '1-Yellow Block'
if (( @CandBlockStatus = 2 and @CandBlockProjectsID > 0 and ISNULL(@CandBlockProjectsID,0)<>@CurProjectsID))
OR ( @CandBlockStatus = 2 and ISNULL(@CandBlockProjectsID,0)=0 and @ManualBlockUntilDate is not null and @ManualBlockUntilDate >GETDATE())
OR ( @PlacedBlockStatus = 2 and @PlacedBlockUntilDate is not null and @PlacedBlockUntilDate >GETDATE()) 
OR ( @ClientTeamBlockStatus = 2 and @ClientTeamBlockUntilDate is not null and @ClientTeamBlockUntilDate>GETDATE())
	set @Ret = '2-Red Block'
RETURN @Ret
END
GO
GRANT  EXECUTE   ON [dbo].[fn_GetPersonBlockNew]  TO [DeskFlowUsers]


