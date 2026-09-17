if ( select COUNT(*) from ActivityTypes where TypeName='People Merge') =0
insert into ActivityTypes ( TypeName ) values ('People Merge')
