create index ix_Positions_PeoplePrimary on Positions(PeopleID, isPrimaryPosition)
go

create index ix_EmailAddress_PeoplePrimary on EmailAddress(PeopleID, IsPrimaryAddress) include(Address, AddressInvalid)
go