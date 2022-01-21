declare @assembly_name varchar(max) = 'TestProject'
declare @assembly_path varchar(max) = 'E:\Coding\uni_sql\sem6\lab3\assembly\bin\Debug\net461\Test.dll'

-- exec CreateAssemblyWithLogin @assembly_name, @assembly_path
-- go

exec RefreshAssembly @assembly_name, @assembly_path
go