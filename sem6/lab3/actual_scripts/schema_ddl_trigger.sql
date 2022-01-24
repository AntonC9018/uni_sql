--use Universitate
--go

--create schema DDLTriggers_TestSchema
--go

--create table DDLTriggers_TestSchema.TestTable (
--    id        int not null primary key identity(1, 1),
--    credits   int not null)
--go


use Universitate
go

-- create or alter trigger NoCreditsChange_LogWhenNewColumnAdded_TestTable_Trigger
-- on database
-- for alter_table
-- as
-- begin
--     print convert(nvarchar(max), eventdata(), 1);
--     rollback;
-- end
-- go

create or alter trigger NoCreditsChange_LogWhenNewColumnAdded_TestTable_Trigger
on database
for alter_table
as 
    external name TestProject.Test.Stuff
go

