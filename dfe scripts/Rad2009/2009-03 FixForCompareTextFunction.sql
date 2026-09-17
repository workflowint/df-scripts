ALTER function [dbo].[CompareText]  (@String1 varchar (255), @String2 varchar (255))
returns integer
--Function CompareText
--     This function accepts two string values and returns an integer value between
--zero and one hundred indicating the similarity between the two string.  This
--algorithm was developed specifically to search for similar names, spelling
--variations, and typos in proper names and business names.  For this purpose,
--it is superior to SOUNDEX, which searches only for similar sounding words.
--     Proper name pairs which yield a CompareText value above 80 are very likely to
--represent the same person.  Pair values greater than 60 should be reviewed
--manually to confirm the match.  For greater accuracy and efficiency, run the names
--through the MatchText function to remove spaces and vowels before submitting them
--to comparetext.
--     For efficiency in comparing two large lists of names, it is best to join
--the sets on another column as well, such as zip code, or city name.

begin

declare @Possibles integer
declare @Hits integer
declare @Counter integer
declare @RetValue integer

set @Possibles = len(@String1) + len(@String2) - 2
set @Hits = 0
set @RetValue = 0

set @Counter = len(@String1)-1
while @Counter > 0
    begin
      if charindex(substring(@String1, @Counter, 2), @String2) > 0 set @Hits = 

@Hits + 1
      set @Counter = @Counter - 1
    end

set @Counter = len(@String2)-1
while @Counter > 0
    begin
      if charindex(substring(@String2, @Counter, 2), @String1) > 0 set @Hits = 

@Hits + 1
      set @Counter = @Counter - 1
    end
if ( @Possibles >0 ) 
	set @RetValue = (100*@Hits)/@Possibles
return @RetValue
end






