ALTER TRIGGER [dbo].[PositionsINSERT] ON [dbo].[Positions]
FOR INSERT 
AS
BEGIN

IF EXISTS( SELECT ProjectsCallStatusID FROM ProjectsCallStatus, Inserted WITH(NOLOCK) 
WHERE ProjectsCallStatus.PeopleID = Inserted.PeopleID AND ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND Inserted.ProjectsID > 0)
	UPDATE ProjectsCallStatus SET InclPL = 1
	FROM Inserted,ProjectsCallStatus WHERE 
	(ProjectsCallStatus.ProjectsID = Inserted.ProjectsID AND ProjectsCallStatus.PeopleID = Inserted.PeopleID)

UPDATE  Positions
SET  Positions.CurrencyType = ClientConfig.MainCurrency,
Positions.ExchangeRate =ExchangeRates.CurrentRate
FROM Inserted,  Positions,ClientConfig WITH(NOLOCK) LEFT JOIN 
ExchangeRates WITH(NOLOCK) on ( ClientConfig.MainCurrency = ExchangeRates.CurrencyUnit)
WHERE Inserted.PositionsID =  Positions.PositionsID
and IsNull(Positions.CurrencyType,'')='' and ClientConfig.MainCurrency is not null


END