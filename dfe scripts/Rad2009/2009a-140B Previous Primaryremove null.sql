ALTER TABLE Positions DISABLE TRIGGER PositionsUpdate
UPDATE Positions SET IsPrevPrimaryPosition = 0 where IsPrevPrimaryPosition IS NULL
ALTER TABLE Positions ENABLE TRIGGER PositionsUpdate
