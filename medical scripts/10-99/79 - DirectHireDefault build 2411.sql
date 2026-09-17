ALTER TABLE People add Phone4IsInvalid bit
GO
ALTER TABLE People add Phone5IsInvalid bit
GO
ALTER TABLE People add CustomText6 varchar(255)
GO
ALTER TABLE People add CustomText7 varchar(255)
GO
ALTER TABLE PositionStatus add DirectHireDefault bit
GO
Update PositionStatus set DirectHireDefault=0 where DirectHireDefault is null
GO
if (select count(*) from PositionStatus where DirectHireDefault=1)=0
	update  PositionStatus set DirectHireDefault=1 where Status='Open'

