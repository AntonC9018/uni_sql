create or alter procedure ReCreateTestLogin(
    @login_name nvarchar(max))
as
begin
    if exists(
        select name
        from sys.server_principals
        where name = @login_name)
    begin
        declare login_connections_cursor cursor
        for select session_id 
            from sys.dm_exec_sessions
            where login_name = @login_name;
        open login_connections_cursor;

        declare @session_id smallint;

        fetch next 
        from login_connections_cursor
        into @session_id;

        while @@fetch_status = 0
        begin
            exec('kill ' + @session_id);

            fetch next 
            from login_connections_cursor
            into @session_id;
        end

        close login_connections_cursor;
        deallocate login_connections_cursor;

        exec sp_droplogin @login_name;
    end

    exec sp_addlogin @login_name, '1111';
end
go

-- We need a user to privide context to the trigger.
-- Otherwise it cannot see or query any tables.
create or alter procedure MaybeCreateLogonTriggerContextLogin
as
begin
    if exists(
        select name 
        from sys.server_principals
        where name = 'logon_trigger_context_login')
    begin
        return;
    end

    exec sp_addlogin 'logon_trigger_context_login', 'q9u7hy8u3i%^#&*^*sSFJAPOQ';
    
    -- Needed for it to query dm_* tables (DMO's), I think.
    -- System tables are included in this too, I think.
    grant view server state
    to logon_trigger_context_login;

    -- Need a user to be able to insert into user tables.
    exec sp_adduser 'logon_trigger_context_login', 'logon_trigger_context_user';

    -- Without this permission it could not modify the tables.
    grant select, insert
    on LogonMaster_AuditTable
    to logon_trigger_context_user;
end

if object_id(N'dbo.LogonMaster_AuditTable', N'U') is null
    create table LogonMaster_AuditTable (
        id                int not null primary key identity(1, 1),
        ip_address        nvarchar(max) not null,
        login_name        nvarchar(max) not null,
        logon_date        date not null,
        is_logon_allowed  bit not null)
go

exec MaybeCreateLogonTriggerContextLogin
go

create or alter trigger LogonMasterTrigger
on all server
with execute as 'logon_trigger_context_login'
for logon
as
begin
    -- There is another function that does the same.
    declare @ip_address nvarchar(max) = eventdata()
        .value('(/EVENT_INSTANCE/ClientHost)[1]', 'nvarchar(max)');

    declare @is_logon_allowed  bit           = 1;
    declare @login_name        nvarchar(max) = original_login();
    declare @logon_date        date          = getdate();

    -- Always let admins log on.
    if is_srvrolemember('sysadmin', @login_name) = 0
    begin
        -- Block hackers.
        if @login_name like '%hacker%'
        begin
            print formatmessage('Connection not allowed for "%s": hackers not allowed.', 
                @login_name, @login_name);
            set @is_logon_allowed = 0;
        end

        -- Get all logons that took place from that login in the last 5 minutes.
        if @is_logon_allowed = 1
        begin
            declare @connection_limit_duration_seconds int = 5 * 60;
            declare @connection_limit_max_logon_count  int = 15;
            declare @actual_logon_count int;

            select @actual_logon_count = count(*)
            from LogonMaster_AuditTable
            where datediff(second, logon_date, @logon_date) < @connection_limit_duration_seconds
                and login_name = @login_name;
            
            if @actual_logon_count >= @connection_limit_max_logon_count
            begin
                print formatmessage('Connection not allowed for "%s": too many connection attempts (max is %d, the current count is %d).', 
                    @login_name, @connection_limit_max_logon_count, @actual_logon_count);
                set @is_logon_allowed = 0;
            end
        end

        -- Check concurrent session count.
        if @is_logon_allowed = 1
        begin
            declare @max_concurrent_session_count smallint = 3;
            declare @actual_session_count smallint;

            select @actual_session_count = count(*)
            from sys.dm_exec_sessions
            where is_user_process = 1
                and original_login_name = @login_name

            if @actual_session_count > @max_concurrent_session_count
            begin
                print formatmessage('Connection not allowed for "%s": too many concurrent sessions (max is %d, the current count is %d).', 
                    @login_name, @max_concurrent_session_count, @actual_session_count);
                set @is_logon_allowed = 0;
            end
        end

        if @is_logon_allowed = 0
        begin
            -- We need to push the new data into the table after we deny the logon.
            -- https://docs.microsoft.com/en-us/sql/relational-databases/triggers/logon-triggers?view=sql-server-ver15#managing-transactions
            rollback transaction;
        end
    end

    insert into LogonMaster_AuditTable(
        ip_address,
        login_name,
        logon_date,
        is_logon_allowed)
    values (
        @ip_address,
        @login_name,
        @logon_date,
        @is_logon_allowed
    );
end
go