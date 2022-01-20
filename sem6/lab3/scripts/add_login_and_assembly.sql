use master;
go

create or alter procedure [dbo].[DoAssemblyStuff](
    @assembly_name varchar(max),
    @assembly_full_path varchar(max))
as
begin
    declare @key_name   varchar(max) = @assembly_name + '_Key'
    declare @login_name varchar(max) = @assembly_name + '_Login'

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

    declare @create_assembly_command_text varchar(max) = formatmessage(
		'create assembly %s
        from ''%s''
        with permission_set = SAFE', @assembly_name, @assembly_full_path)
		

    declare @is_debug int = 1

    if @is_debug = 1
    begin
        print @create_key_command_text
        print @create_login_command_text
        print @grant_external_access_command_text
        print @grant_unsafe_assembly_command_text
        print @create_assembly_command_text
    end
    begin
        exec(@create_key_command_text)
        exec(@create_login_command_text)
        exec(@grant_external_access_command_text)
        exec(@grant_unsafe_assembly_command_text)
        exec(@create_assembly_command_text)
    end
end
go


declare @assembly_name varchar(max) = 'TestProject'
declare @assembly_path varchar(max) = 'E:\Coding\uni_sql\sem6\lab3\assembly\bin\Debug\net461\Test.dll'

exec DoAssemblyStuff @assembly_name, @assembly_path
go