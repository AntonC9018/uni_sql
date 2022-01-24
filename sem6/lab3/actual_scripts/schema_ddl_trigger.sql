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

-- drop function TriggerInternalFunction
-- go


-- create or alter function TriggerInternalFunction()
-- returns bit
-- as 
--     external name TestProject.Test.Stuff
-- go


create or alter trigger NoCreditsChange_LogWhenNewColumnAdded_TestTable_Trigger
on database
for alter_table
as
    external name TestProject.Test.Stuff
-- begin
    -- declare @should_rollback bit = dbo.TriggerInternalFunction();
    -- if (@should_rollback = 1)
    -- begin
    --     rollback transaction;
    -- end
-- end
go

