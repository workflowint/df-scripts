ALTER TABLE ClientConfig add CallStatusFourthImage int
go
update ClientConfig set CallStatusFourthImage =0
