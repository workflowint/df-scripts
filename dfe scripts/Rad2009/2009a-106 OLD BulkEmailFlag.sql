ALTER TABLE People 
ADD CanReceiveBulkEmail BIT NOT NULL 
CONSTRAINT DF_People_CanReceiveBulk DEFAULT(0)