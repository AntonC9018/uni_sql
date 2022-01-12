# Laborator 1 la Securitatea BD

A elaborat: **Curmanschii Anton, IA1901.**

Tema: **Managementul accesului la BD.**


## Sarcinile

- Creați baza de date "Universitate".

- Pentru baza de date creată îndepliniți următoarele:

1. Creați 4 identificatori: `CurmanschiiAnton_id1`, `CurmanschiiAnton_id2`, `CurmanschiiAnton_id3`, `CurmanschiiAnton_id4` pentru baza de date `Universitate`;
2. Modificați parola pentru identificatorul `CurmanschiiAnton_id1`;
3. Afișați lista tuturor identificatorilor;
4. Utilizând cei 4 identificatori, creați 4 utilizatori respectiv: `CurmanschiiAnton_bd1`, `CurmanschiiAnton_bd2`, `CurmanschiiAnton_bd3`, `CurmanschiiAnton_bd4`;
5. Utilizatorului `CurmanschiiAnton_bd1` acordați privilegiul `Select`, `Insert`, `Update` și `Delete` pentru tabelul
`CurmanschiiAnton_Student`, `CurmanschiiAnton_Profesor` și `CurmanschiiAnton_Facultate`;
6. Crează rolul `CurmanschiiAnton_rol1` cu privilegiul `Select`, `Insert` și `Update` pentru tabelele `CurmanschiiAnton_Curs`,
`CurmanschiiAnton_Curs_Student`, `CurmanschiiAnton_Examen`;
7. Crează rolul `CurmanschiiAnton_rol2` cu privilegiul `Select`, `Insert` și `Update` pentru tabelele `CurmanschiiAnton_Grad_Stiintific` și
`CurmanschiiAnton_Profesor`;
8. Asignează rolul `CurmanschiiAnton_rol1` și `CurmanschiiAnton_rol2` utilizatorului `CurmanschiiAnton_bd2`;
9. Crează rolul `CurmanschiiAnton_rol3` cu privilegiile `Select` și `Update` pentru tabelele `CurmanschiiAnton_Student` și `CurmanschiiAnton_Profesor`;
10. Asignează rolul `CurmanschiiAnton_rol3` utilizatorului `CurmanschiiAnton_bd3`;
11. Revocă utilizatorului `CurmanschiiAnton_bd1` privilegiul `Delete` și `Update` pentru tabelul `CurmanschiiAnton_Profesor`;
12. Crează rolul `CurmanschiiAnton_rol4` cu privilegiul `Insert` și `Update` pentru tabelul `CurmanschiiAnton_Examen`;
13. Asignează rolul `CurmanschiiAnton_rol4` utilizatorului `CurmanschiiAnton_bd4`;
14. Acordă utilizatorului `CurmanschiiAnton_bd4` privilegiul `Select` pentru tabelul `CurmanschiiAnton_Examen` și `CurmanschiiAnton_Student`;
15. Utilizatorului `CurmanschiiAnton_bd4` scoate dreptul `Insert` pentru tabelul `CurmanschiiAnton_Examen`;
16. Afișază rolurile utilizatorului `CurmanschiiAnton_bd2`;
17. Exclude rolul `CurmanschiiAnton_rol1` de la utilizatorul `CurmanschiiAnton_bd2`;
18. Șterge rolul `CurmanschiiAnton_rol1`.


## Realizarea

> Creați baza de date "Universitate".

Mă orientez după informații din [următorul articol din documentația MS](https://docs.microsoft.com/en-us/sql/t-sql/lesson-1-creating-database-objects?view=sql-server-ver15).

Utilizând comanda `create database` putem crea o bază de date:

```sql
create database Universitate
```

Verificăm lista bazelor de date prin comanda `exec sp_databases`. 
Vedem baza de date nouă în lista, deci comanda a lucrat corect.

|   | DATABASE_NAME | DATABASE_SIZE | REMARKS |
|---|---------------|---------------|---------|
| 1 | master        | 6592          | NULL    |
| 2 | model         | 16384         | NULL    |
| 3 | msdb          | 15872         | NULL    |
| 4 | tempdb        | 40960         | NULL    |
| 5 | Universitate  | 16384         | NULL    |


Acum creăm tabelele:

```sql
use Universitate
go

create table CurmanschiiAnton_Student(
    id          int primary key not null,
    nume        nvarchar(50) not null,
    prenume     nvarchar(50) not null,
    an_nastere  date not null,
    an_studii   tinyint not null,
    sex         char(1) null)
go

create table CurmanschiiAnton_Facultate(
    id          int primary key not null,
    nume        nvarchar(50) not null)
go

create table CurmanschiiAnton_GradStiintific(
    id          int primary key not null,
    nume        nvarchar(50) not null)
go

create table CurmanschiiAnton_Profesor(
    id                  int primary key not null,
    nume                nvarchar(50) not null,
    prenume             nvarchar(50) not null,
    id_grad_stiintific  int foreign key references CurmanschiiAnton_GradStiintific(id) not null)
go

create table CurmanschiiAnton_Curs(
    id           int primary key not null,
    nume         nvarchar(50) not null,
    id_facultate int foreign key references CurmanschiiAnton_Facultate(id) not null)
go

create table CurmanschiiAnton_CursProfesor(
    id          int primary key not null,
    id_curs     int foreign key references CurmanschiiAnton_Curs(id) not null,
    id_profesor int foreign key references CurmanschiiAnton_Profesor(id) not null)
go

create table CurmanschiiAnton_Examen(
    id          int primary key not null,
    id_curs     int foreign key references CurmanschiiAnton_Curs(id) not null,
    id_profesor int foreign key references CurmanschiiAnton_Profesor(id) not null,
    id_student  int foreign key references CurmanschiiAnton_Student(id) not null,
    nota        tinyint not null)
go

create table CurmanschiiAnton_CursStudent(
    id          int primary key not null,
    id_student  int foreign key references CurmanschiiAnton_Student(id) not null,
    id_curs     int foreign key references CurmanschiiAnton_Curs(id) not null,
    id_profesor int foreign key references CurmanschiiAnton_Profesor(id) not null)
go
```


Diagrama de dependențe rezultantă:

![Diagrama rezultantă](images/diagram.png)


> 1\. Creați 4 identificatori: `CurmanschiiAnton_id1`, `CurmanschiiAnton_id2`, `CurmanschiiAnton_id3`, `CurmanschiiAnton_id4` pentru baza de date `Universitate`.

Avem 2 comenzi pentru crearea unui identificator (sau a unui *login*), [`sp_addlogin`](https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addlogin-transact-sql?view=sql-server-ver15) sau [`CREATE LOGIN`](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=sql-server-ver15).
`sp_addlogin` este opțiunea învechită și va fi eliminată.
Voi folosi ambele versiune de creare a identificatorilor.


```sql
exec sp_addlogin 'CurmanschiiAnton_id1', '1234', 'Universitate'
go

exec sp_addlogin 'CurmanschiiAnton_id2', '1234', 'Universitate'
go

create login CurmanschiiAnton_id3 
with password         = '1234',
     default_database = Universitate
go

create login CurmanschiiAnton_id4 
with password         = '1234',
     default_database = Universitate
go
```


> 2\. Modificați parola pentru identificatorul CurmanschiiAnton_id1.

Aici iarăși avem procedura deprecată [`sp_password`](https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-password-transact-sql?view=sql-server-ver15) și cea nouă [`alter login`](https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-login-transact-sql?view=sql-server-ver15).

```sql
exec sp_password 
    @old      = '1234',
    @new	  = '1111',
    @loginame = 'CurmanschiiAnton_id2'
go

alter login CurmanschiiAnton_id1 
with password = '1111'
go
```


> 3\. Afișați lista tuturor identificatorilor.

[`sys.sql_logins`](https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-sql-logins-transact-sql?view=sql-server-ver15)

```sql
select name from sys.sql_logins
```


|   | name                                  |
|---|---------------------------------------|
| 1 | sa                                    |
| 2 | \#\#MS_PolicyEventProcessingLogin\#\# |
| 3 | \#\#MS_PolicyTsqlExecutionLogin\#\#   |
| 4 | CurmanschiiAnton_id1                  |
| 5 | CurmanschiiAnton_id2                  |
| 6 | CurmanschiiAnton_id3                  |
| 7 | CurmanschiiAnton_id4                  |


> 4\. Utilizând cei 4 identificatori, creați 4 utilizatori respectiv: `CurmanschiiAnton_bd1`, `CurmanschiiAnton_bd2`, `CurmanschiiAnton_bd3`, `CurmanschiiAnton_bd4`.

[`create user`](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-ver15)


```sql
create user CurmanschiiAnton_bd1 from login CurmanschiiAnton_id1
create user CurmanschiiAnton_bd2 from login CurmanschiiAnton_id2
create user CurmanschiiAnton_bd3 from login CurmanschiiAnton_id3
create user CurmanschiiAnton_bd4 from login CurmanschiiAnton_id4
go

select name
from sys.database_principals
where name like 'Curm%'
go
```

|   | name                 |
|---|----------------------|
| 1 | CurmanschiiAnton_bd1 |
| 2 | CurmanschiiAnton_bd2 |
| 3 | CurmanschiiAnton_bd3 |
| 4 | CurmanschiiAnton_bd4 |


> 5\. Utilizatorului `CurmanschiiAnton_bd1` acordați privilegiul `Select`, `Insert`, `Update` și `Delete` pentru tabelul `CurmanschiiAnton_Student`, `CurmanschiiAnton_Profesor` și `CurmanschiiAnton_Facultate`.


```sql
use Universitate

grant select, insert, update, delete 
on CurmanschiiAnton_Student
to CurmanschiiAnton_bd1

grant select, insert, update, delete 
on CurmanschiiAnton_Profesor
to CurmanschiiAnton_bd1

grant select, insert, update, delete 
on CurmanschiiAnton_Facultate
to CurmanschiiAnton_bd1
go
```

> 6\. Crează rolul `CurmanschiiAnton_rol1` cu privilegiul `Select`, `Insert` și `Update` pentru tabelele `CurmanschiiAnton_Curs`.

[`create role`](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-role-transact-sql?view=sql-server-ver15)

```sql
create role CurmanschiiAnton_rol1

use Universitate

grant select, insert, update
on CurmanschiiAnton_Curs
to CurmanschiiAnton_rol1
go

select name
from sys.database_principals
where name like 'Curm%'
go
```


|   | name                  |
|---|-----------------------|
| 1 | CurmanschiiAnton_bd1  |
| 2 | CurmanschiiAnton_bd2  |
| 3 | CurmanschiiAnton_bd3  |
| 4 | CurmanschiiAnton_bd4  |
| 5 | CurmanschiiAnton_rol1 |


> 7\. Crează rolul `CurmanschiiAnton_rol2` cu privilegiul `Select`, `Insert` și `Update` pentru tabelele `CurmanschiiAnton_Grad_Stiintific` și `CurmanschiiAnton_Profesor`.

```sql
create role CurmanschiiAnton_rol2

use Universitate

grant select, insert, update
on CurmanschiiAnton_Grad_Stiintific
to CurmanschiiAnton_rol1

grant select, insert, update
on CurmanschiiAnton_Profesor
to CurmanschiiAnton_rol1
go

select name
from sys.database_principals
where name like 'Curm%'
go
```

|   | name                  |
|---|-----------------------|
| 1 | CurmanschiiAnton_bd1  |
| 2 | CurmanschiiAnton_bd2  |
| 3 | CurmanschiiAnton_bd3  |
| 4 | CurmanschiiAnton_bd4  |
| 5 | CurmanschiiAnton_rol1 |
| 6 | CurmanschiiAnton_rol2 |


> 8\. Asignează rolul `CurmanschiiAnton_rol1` și `CurmanschiiAnton_rol2` utilizatorului `CurmanschiiAnton_bd2`.

```sql
alter role CurmanschiiAnton_rol1
add member CurmanschiiAnton_bd2

alter role CurmanschiiAnton_rol2
add member CurmanschiiAnton_bd2
go
```


> 9\. Crează rolul `CurmanschiiAnton_rol3` cu privilegiile `Select` și `Update` pentru tabelele `CurmanschiiAnton_Student` și `CurmanschiiAnton_Profesor`.

```sql
create role CurmanschiiAnton_rol3

use Universitate

grant select, update
on CurmanschiiAnton_Profesor
to CurmanschiiAnton_rol3

grant select, update
on CurmanschiiAnton_Student
to CurmanschiiAnton_rol3
go
```

> 10\. Asignează rolul `CurmanschiiAnton_rol3` utilizatorului `CurmanschiiAnton_bd3`.

```sql
alter role CurmanschiiAnton_rol3
add member CurmanschiiAnton_bd3
```

> 11\. Revocă utilizatorului `CurmanschiiAnton_bd1` privilegiul `Delete` și `Update` pentru tabelul `CurmanschiiAnton_Profesor`.

[`revoke`](https://docs.microsoft.com/en-us/sql/t-sql/statements/revoke-object-permissions-transact-sql?view=sql-server-ver15).

```sql
use Universitate

revoke delete, update
on   CurmanschiiAnton_Profesor
from CurmanschiiAnton_bd1
```


> 12\. Crează rolul `CurmanschiiAnton_rol4` cu privilegiul `Insert` și `Update` pentru tabelul `CurmanschiiAnton_Examen`.

```sql
create role CurmanschiiAnton_rol4

use Universitate

grant insert, update
on CurmanschiiAnton_Examen
to CurmanschiiAnton_rol4
```


> 13\. Asignează rolul `CurmanschiiAnton_rol4` utilizatorului `CurmanschiiAnton_bd4`.

```sql
alter role CurmanschiiAnton_rol4
add member CurmanschiiAnton_bd4
```

> 14\. Acordă utilizatorului `CurmanschiiAnton_bd4` privilegiul `Select` pentru tabelul `CurmanschiiAnton_Examen` și `CurmanschiiAnton_Student`.

```sql
use Universitate

grant select
on CurmanschiiAnton_Examen
to CurmanschiiAnton_bd4

grant select
on CurmanschiiAnton_Student
to CurmanschiiAnton_bd4
go
```

> 15\. Utilizatorului `CurmanschiiAnton_bd4` scoate dreptul `Insert` pentru tabelul `CurmanschiiAnton_Examen`.

```sql
use Universitate

revoke insert
on   CurmanschiiAnton_Examen
from CurmanschiiAnton_bd4
```

> 16\. Afișează rolurile utilizatorului `CurmanschiiAnton_bd2`.

Deci ideea este că selectăm utilizatorul cu numele `CurmanschiiAnton_bd2`, îi luăm id-ul, ne ducem la tabelul `sys.database_role_members` ce conține maparea `id rolului` -> `id membru`, luăm acele id-urile rolului unde id-urile membrului sunt egale cu id-ul lui `CurmanschiiAnton_bd2`, pe urmă ne uităm iarăși în primul tabel pentru a afișa numele acestui rol.

```sql
select principals2.name
from sys.database_principals as principals
inner join sys.database_role_members as members
on principals.principal_id = members.member_principal_id
inner join sys.database_principals as principals2
on principals2.principal_id = members.role_principal_id
where principals.name = 'CurmanschiiAnton_bd2'
```

|   | name                  |
|---|-----------------------|
| 1 | CurmanschiiAnton_rol1 |
| 2 | CurmanschiiAnton_rol2 |

> 17\. Exclude rolul `CurmanschiiAnton_rol1` de la utilizatorul `CurmanschiiAnton_bd2`.


```sql
alter role CurmanschiiAnton_rol1
drop member CurmanschiiAnton_bd2
```

|   | name                  |
|---|-----------------------|
| 1 | CurmanschiiAnton_rol2 |


> 18\. Șterge rolul `CurmanschiiAnton_rol1`.

```sql
drop role CurmanschiiAnton_rol1
```
