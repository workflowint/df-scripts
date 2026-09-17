create index ix_gdpr_token on gdprlinks(token)
go

create index ix_gdpr_peopleid on gdprlinks(peopleid) include(token)
go