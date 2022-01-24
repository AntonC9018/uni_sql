use master;
go

create or alter function [dbo].[GetAssemblyKeyName](
    @assembly_name varchar(max))
returns varchar(max)
as
begin
    declare @result varchar(max) = @assembly_name + '_Key';
    return(@result);
end
go

create or alter function [dbo].[GetAssemblyLoginName](
    @assembly_name varchar(max))
returns varchar(max)
as
begin
    declare @result varchar(max) = @assembly_name + '_Login';
    return(@result);
end
go


create or alter procedure [dbo].[CreateAssemblyLogin](
    @assembly_name varchar(max),
    @assembly_full_path varchar(max))
as
begin
    declare @key_name   varchar(max) = dbo.GetAssemblyKeyName(@assembly_name);
    declare @login_name varchar(max) = dbo.GetAssemblyLoginName(@assembly_name);

    declare @create_key_command_text varchar(max) = formatmessage(
        'create asymmetric key %s 
        from executable file = ''%s''',
        @key_name, @assembly_full_path)

    declare @create_login_command_text varchar(max) = formatmessage(
        'create login %s 
        from asymmetric key %s',
        @login_name, @key_name)

    declare @grant_external_access_command_text varchar(max) = formatmessage(
        'grant external access assembly to %s', @login_name)
    
	declare @grant_unsafe_assembly_command_text varchar(max) = formatmessage(
		'grant unsafe assembly to %s', @login_name)

    declare @is_debug int = 1

    if @is_debug = 1
    begin
        print @create_key_command_text
        print @create_login_command_text
        print @grant_external_access_command_text
        print @grant_unsafe_assembly_command_text
    end
    begin
        exec(@create_key_command_text)
        exec(@create_login_command_text)
        exec(@grant_external_access_command_text)
        exec(@grant_unsafe_assembly_command_text)
    end
end
go


create or alter procedure [dbo].[DropAssemblyLogin](
@assembly_name varchar(max),
    @assembly_full_path varchar(max))
as
begin
    declare @key_name   varchar(max) = dbo.GetAssemblyKeyName(@assembly_name);
    declare @login_name varchar(max) = dbo.GetAssemblyLoginName(@assembly_name);

    declare @drop_login_command_text varchar(max) = 'drop login ' + @login_name;
    exec(@drop_login_command_text);

    declare @drop_key_command_text varchar(max) = 'drop asymmetric key ' + @key_name;
    exec(@drop_key_command_text);
end
go
