void main()
{
    const projectName = "TestProject";
    const relativePath = `..\assembly\bin\Debug\net461\Test.dll`;

    import std.stdio;
    import std.path;
    
    writeln(`
declare @assembly_name varchar(max) = '`, projectName, `'
declare @assembly_path varchar(max) = '`, absolutePath(relativePath), `'

exec CreateAssemblyWithLogin @assembly_name, @assembly_path
go

exec RefreshAssembly @assembly_name, @assembly_path
go`);
}