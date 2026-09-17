ALTER TABLE PositionStatus add ForMRContract bit NULL, SearchOnly bit NULL
GO 
UPDATE PositionStatus set ForMRContract=0 where ForMRContract is null