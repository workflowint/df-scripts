ALTER TABLE ClientConfig add PeopleBanner3Line varchar(255)
GO
if ( Select IsNull(DATALENGTH(PeopleBanner3Line),0) from ClientConfig)=0
UPDATE ClientConfig set PeopleBanner3Line='[*Base:*][*Salary*][*Bonus:*][*Bonus*]'
GO
ALTER TABLE LinkPeopleToNetWork add Notes text

