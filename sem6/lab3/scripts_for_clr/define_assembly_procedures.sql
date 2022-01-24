use Universitate
go

create or alter procedure [dbo].[CreateAssembly](
    @assembly_name varchar(max),
    @assembly_full_path varchar(max))
as
begin
    declare @create_assembly_command_text varchar(max) = formatmessage(
		'create assembly %s
        from ''%s''
        with permission_set = SAFE', @assembly_name, @assembly_full_path)
    exec(@create_assembly_command_text)
end
go