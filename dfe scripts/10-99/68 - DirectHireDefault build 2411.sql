ALTER TABLE PositionStatus add DirectHireDefault bit
GO
Update PositionStatus set DirectHireDefault=0 where DirectHireDefault is null
GO
if (select count(*) from PositionStatus where DirectHireDefault=1)=0
	update  PositionStatus set DirectHireDefault=1 where Status='Open'

