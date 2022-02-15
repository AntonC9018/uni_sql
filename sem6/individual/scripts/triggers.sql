
create table Scoala.StudentAudit (
	id              int not null identity(1, 1),
    
    student_id      int not null,
    nume            nvarchar(128) not null,
    prenume         nvarchar(128) not null,
    data_de_nastere date not null,

	tip           char(1) not null,
	modifiedby    varchar(255) not null,
	modifieddate  datetime null,

    constraint StudentAudit_PK
    primary key (id)
);
go

create trigger Scoala.DDLTriggerStudent on Scoala.Student
for insert, update, delete
as begin
	if @@rowcount = 0
		return;

	declare @tip_op char(1);
    if exists(select * from inserted) and exists(select * from deleted)
        set @tip_op = 'U'
    else if exists(select * from inserted)
        set @tip_op = 'I'
    else
        set @tip_op = 'D'

    if exists(select * from inserted)
		insert into Scoala.StudentAudit(
            student_id,
            nume,
            prenume,
            data_de_nastere,
            tip,
            modifiedby,
            modifieddate)
		select 
            id,
            nume,
            prenume,
            data_de_nastere,
            @tip_op,
            suser_sname(),
            getdate() 
        from inserted;

    if exists(select * from deleted)
		insert into Scoala.StudentAudit(
            student_id,
            nume,
            prenume,
            data_de_nastere,
            tip,
            modifiedby,
            modifieddate)
		select 
            id,
            nume,
            prenume,
            data_de_nastere,
            @tip_op,
            suser_sname(),
            getdate() 
        from deleted;
end
go

create table DDLEvents 
(
    eventdate       datetime not null default current_timestamp,
    eventtype       nvarchar(64),
    eventddl        nvarchar(max),
    eventxml        xml,
    dbname          nvarchar(255),
    schemaname      nvarchar(255),
    objname         nvarchar(255),
    hostname        varchar(64),
    ipaddress       varchar(48),
    programname     nvarchar(255),
    loginname       nvarchar(255)
);
go

create trigger DLLSchemaChangeTrigger
    on database
    for create_procedure, alter_procedure, drop_procedure,
    create_table, alter_table, drop_table,
    create_function, alter_function, drop_function,
    create_index, alter_index, drop_index,
    create_view, alter_view, drop_view,
    create_trigger, alter_trigger, drop_trigger
as begin
    set nocount on;
    declare @eventdata xml = eventdata();
    declare @ip varchar(48) = convert(varchar(48), connectionproperty('client_net_address'));
    insert into DDLEvents (eventtype, eventddl, eventxml, dbname, schemaname, objname, hostname, ipaddress, programname, loginname)
    select 
    @eventdata.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'),
    @eventdata.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'),
    @eventdata,
    db_name(),
    @eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]', 'nvarchar(255)'),
    @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(255)'),
    host_name(),
    @ip,
    program_name(),
    suser_sname();
end
go