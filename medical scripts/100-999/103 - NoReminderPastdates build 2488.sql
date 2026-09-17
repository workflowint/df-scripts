ALTER TABLE Responces add NoReminderPastDates bit
GO
UPDATE LookupTables set Editable ='Name' where Name='Priority'
GO
ALTER TABLE Priority add Color int, FontColor int