ALTER TABLE Education
ADD [AddressesID] [int] NULL,
	[City] [varchar](50) NULL,
	[Province] [varchar](50) NULL

GO
/****** Object:  Trigger [dbo].[AddressesUpdate]    Script Date: 10/29/2014 17:09:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  TRIGGER [dbo].[AddressesUpdate] ON [dbo].[Addresses]
FOR UPDATE 
NOT FOR REPLICATION
AS
UPDATE Addresses
SET Addresses.UpdatedBy = suser_sname(),
UpdatedOn = GETDATE()
FROM Inserted, Addresses 
WHERE Inserted.AddressesID = Addresses.AddressesID

UPDATE Positions SET  Positions.Location = 
LTRIM(RTRIM(ISNULL(Inserted.Address1,'')+' '+ISNULL(Inserted.City,'')+
', '+LTRIM(RTRIM(ISNULL(Inserted.Province,'')))+' '+ISNULL(Inserted.Country,'')))
FROM Inserted,Positions,Deleted
WHERE Inserted.AddressesID=Positions.AddressesID
AND Deleted.AddressesID =  Inserted.AddressesID
AND ((Deleted.Address1<>Inserted.Address1) OR (Deleted.City<>Inserted.City)
OR (Deleted.Province<>Inserted.Province) OR (Deleted.Country<>Inserted.Country) OR
(Deleted.Address1 is null and Inserted.Address1 is not null ) 
OR (Deleted.City is null and Inserted.City is not null)
OR (Deleted.Province is null and Inserted.Province is not null) 
OR (Deleted.Country is null and Inserted.Country is not null))

UPDATE Education SET Education.City = Inserted.City, Education.Province = Inserted.Province
FROM Inserted, Education, Deleted
WHERE Inserted.AddressesID = Education.AddressesID
AND Deleted.AddressesID = Inserted.AddressesID
AND ( (Deleted.City<>Inserted.City)
OR (Deleted.Province<>Inserted.Province)
OR (Deleted.City is null and Inserted.City is not null)
OR (Deleted.Province is null and Inserted.Province is not null) )
