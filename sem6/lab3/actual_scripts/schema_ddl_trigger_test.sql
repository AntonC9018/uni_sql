use Universitate
go

alter table DDLTriggers_TestSchema.TestTable
drop column CrEdItS

alter table DDLTriggers_TestSchema.TestTable
alter column credits nvarchar(10) not null

alter table DDLTriggers_TestSchema.TestTable
add constraint TestTable_C1 check(credits > 5),
    constraint TestTable_C2 check(credits < 15)

-- alter table DDLTriggers_TestSchema.TestTable
-- drop constraint TestTable_C1, TestTable_C2
