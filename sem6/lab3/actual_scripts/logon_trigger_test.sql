exec ReCreateTestLogin 'test_login'

select * from LogonMaster_AuditTable

delete from LogonMaster_AuditTable

exec 
sp_adduser