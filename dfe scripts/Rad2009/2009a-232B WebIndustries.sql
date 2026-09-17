if ( select COUNT(*) from WebPostingsIndustries )=0
INSERT INTO WebPostingsIndustries (WebPostingsIndustriesID,WebJobPostingsID, IndustryCode1,IndustryCode2,
IndustryCode3,IndustryCode4,IndustryCode5,IndustryCode6)
select WebJobPostingsID,WebJobPostingsID, IndustryCode1,IndustryCode2,
IndustryCode3,IndustryCode4,IndustryCode5,IndustryCode6
from WebJobPostings where IndustryCode1>0

GO
update LastIDs
SET LastID=(SELECT ISNULL(max(WebPostingsIndustriesID), 0) FROM WebPostingsIndustries )
WHERE FieldName='WebPostingsIndustriesID'
