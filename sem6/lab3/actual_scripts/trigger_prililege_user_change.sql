use Universitate
go

create schema DDLTriggers_TestSchema
go

create table DDLTriggers_TestSchema.PrivilegeAltered_AuditTable (
    id              int not null primary key identity(1, 1),
    login_name      nvarchar(max) not null,
    user_name       nvarchar(max) not null,
    the_statement   nvarchar(max) not null,
    role_name       nvarchar(max) not null,
    was_added       bit not null)
go

create login privilege_trigger_login
with password = '124124fwdsdf'
go

create user privilege_trigger_user
from login privilege_trigger_login
with default_schema = DDLTriggers_TestSchema
go

grant insert
on DDLTriggers_TestSchema.PrivilegeAltered_AuditTable
to privilege_trigger_user
go

create or alter trigger PrivilegeAltered_UserAdded_AuditTrigger
on database
with execute as 'privilege_trigger_user'
for ADD_ROLE_MEMBER
as
    external name TestProject.AlterUserOrRole.TriggerFunctionAdded
go

create or alter trigger PrivilegeAltered_UserDropped_AuditTrigger
on database
with execute as 'privilege_trigger_user'
for DROP_ROLE_MEMBER
as
    external name TestProject.AlterUserOrRole.TriggerFunctionDropped
go
