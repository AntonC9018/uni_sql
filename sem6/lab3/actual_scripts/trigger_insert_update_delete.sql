use Universitate
go

-- drop trigger Student_InsertUpdateDelete_Trigger

if object_id(N'dbo.StudentAndProfessor_InsertUpdateDelete_AuditTable', N'U') is null
    create table StudentAndProfessor_InsertUpdateDelete_AuditTable (
        id                              int not null primary key
                                        identity(1, 1), -- autoincrement
        name_of_user_who_did_action     nvarchar(max) not null,
        type_of_action                  char(1) not null, -- I, U or D
        affected_row_count              int not null)
    go


create or alter trigger Student_InsertUpdateDelete_Trigger
on CurmanschiiAnton_Student
after insert, update, delete
as
begin
    -- https://docs.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?redirectedfrom=MSDN&view=sql-server-ver15
    -- set nocount on;

    -- https://docs.microsoft.com/en-us/sql/t-sql/functions/rowcount-transact-sql?view=sql-server-ver15
    -- https://www.mssqltips.com/sqlservertip/6091/how-to-use-rowcount-in-sql-server/
    declare @affected_row_count int = @@rowcount;

    -- https://docs.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver15#optimizing-dml-triggers
    if @affected_row_count = 0
        return;

    declare @type_of_action char(1);
    if exists(select * from inserted)
        if exists(select * from deleted)
            set @type_of_action = 'U';
        else
            set @type_of_action = 'I';
    else
        set @type_of_action = 'D';

    -- https://docs.microsoft.com/en-us/sql/t-sql/functions/suser-name-transact-sql?view=sql-server-ver15
    declare @login_name nvarchar(max) = suser_name();

    insert into StudentAndProfessor_InsertUpdateDelete_AuditTable (
        name_of_user_who_did_action,
        type_of_action,
        affected_row_count)
    values (
        @login_name,
        @type_of_action,
        @affected_row_count);
end
go


create or alter procedure Students_InsertUpdateDelete_Test
as
begin
    set nocount on;

    -- essentially recreate the table.
    delete from StudentAndProfessor_InsertUpdateDelete_AuditTable where id >= 0;

    declare @max_student_id int;
    declare @added_students int = 5;

    begin
        -- store this, we will need it.
        select @max_student_id = max(id) from CurmanschiiAnton_Student;

        declare @loop_i int = 0;
        while @loop_i < @added_students
        begin
            insert into CurmanschiiAnton_Student (
                id, 
                nume, 
                prenume,
                an_nastere, 
                an_studii, 
                id_facultate)
            values (
                @loop_i + @max_student_id + 1,
                'RandomName',
                'RandomName2',
                cast('1999-06-09' as date),
                2,
                1);
            set @loop_i = @loop_i + 1;
        end
    end

    begin
        -- we should see 5 things in the table
        declare audit_cursor cursor for
        select type_of_action, affected_row_count from StudentAndProfessor_InsertUpdateDelete_AuditTable
        open audit_cursor;

        declare @type_of_action char(1);
        declare @affected_row_count int;
        declare @counter int = 0;
        declare @fail_flag int = 0;

        fetch next from audit_cursor into @type_of_action, @affected_row_count;
        while @@FETCH_STATUS = 0
        begin
            if @type_of_action != 'I'
            begin
                print 'Failure! Expected action I, got ' + @type_of_action;
                set @fail_flag = 1;
            end
            if @affected_row_count != 1
            begin 
                print 'Failure! Expected affected row count = 1, got ' + @affected_row_count;
                set @fail_flag = 1;
            end
            set @counter = @counter + 1;

            fetch next from audit_cursor into @type_of_action, @affected_row_count;
        end
        close audit_cursor;
        deallocate audit_cursor;

        if @counter != @added_students
        begin
            print formatmessage('Failure! Expected there to be %d messages, got %d.', 
                @added_students, 
                @counter)
            return;
        end

        if @fail_flag != 0
            return;
    end

    delete from CurmanschiiAnton_Student where id >= 5

    begin
        -- validate the count
        begin
            declare @audit_row_count int;
            select @audit_row_count = count(*)
            from StudentAndProfessor_InsertUpdateDelete_AuditTable;

            if @audit_row_count != @added_students 
                + 1 -- the one row added because of the deletion
            begin
                print formatmessage('Failure! Deletion added an amount of row different from 1. Had %d rows, expected %d.',
                    @audit_row_count,
                    @added_students + 1);
                return;
            end
        end
        
        -- mssql does not have scopes, literally unusable trash
        -- declare @type_of_action char(1);
        -- declare @affected_row_count int;

        select top 1 
            @type_of_action     = type_of_action, 
            @affected_row_count = affected_row_count
        from StudentAndProfessor_InsertUpdateDelete_AuditTable
        order by id desc;

        if @type_of_action != 'D'
        begin
            print 'Failure! Expected action type D, got ' + @type_of_action;
            return;
        end

        if @affected_row_count != @added_students
        begin
            print formatmessage('Failure! Expected %d row deleted, got %d',
                @added_students,
                @affected_row_count);
            return;
        end
    end
end
go