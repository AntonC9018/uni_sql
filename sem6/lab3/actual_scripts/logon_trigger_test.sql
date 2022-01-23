exec ReCreateTestLogin 'test_login'

select * from LogonMaster_AuditTable

delete from LogonMaster_AuditTable

exec sp_adduser 'logon_trigger_context_login', 'logon_trigger_context_user'

exec sp_dropuser 'logon_trigger_context_user'
drop trigger LogonMasterTrigger on all server
exec sp_droplogin 'logon_trigger_context_login'

select * from LogonMaster_AuditTable
delete from LogonMaster_AuditTable

alter table LogonMaster_AuditTable
add logon_date datetime not null

drop trigger LogonMasterTrigger on all server
