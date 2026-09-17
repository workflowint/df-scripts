ALTER TABLE ActivityTypes add LinkToCompany bit
GO
update DataCashTables set UpdatedOn=GETUTCDATE() where Name='ActivityTypes'