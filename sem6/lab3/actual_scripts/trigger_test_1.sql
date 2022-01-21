exec Students_InsertUpdateDelete_Test

select * from StudentAndProfessor_InsertUpdateDelete_AuditTable

update CurmanschiiAnton_Student
set nume = 'Viorel'
where id >= 2

select * from StudentAndProfessor_InsertUpdateDelete_AuditTable
where type_of_action = 'U'

select * from CurmanschiiAnton_Student