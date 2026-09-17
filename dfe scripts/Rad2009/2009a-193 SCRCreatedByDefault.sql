ALTER TABLE SearchContactRecord ADD DEFAULT (suser_sname()) FOR CreatedBy
go
ALTER TABLE SearchContactRecord ADD DEFAULT (suser_sname()) FOR UpdatedBY
