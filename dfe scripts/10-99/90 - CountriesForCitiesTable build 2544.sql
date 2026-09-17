CREATE TABLE [dbo].[CountriesForCities](
	[CountryCode] [varchar](10) NULL,
	[Country] [varchar](255) NULL
) ON [PRIMARY]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CountriesForCities]  TO [DeskFlowUsers]
GO
GRANT  REFERENCES ,  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[Cities]  TO [DeskFlowUsers]
