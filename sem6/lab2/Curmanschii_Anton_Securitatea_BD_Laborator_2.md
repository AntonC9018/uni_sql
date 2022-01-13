# Laborator 2 la Securitatea BD

A elaborat: **Curmanschii Anton, IA1901.**

Tema: **Securitatea internă a datelor.**


## Sarcinile

1. Setați câmpul `id` ca `PRIMARY KEY` în fiecare tabel;
2. Pentru `nr_credite` să fie acceptate doar valori în diapazonul $ [3-10] $, `nr_ore` $ [20-300] $, `nota` $ [1-10] $,
`an_nastere` $ [1980-2000] $, `an_studii` $ [1-4] $;
3. Cîmpul `nume` și `prenume` să accepte doar litere cu prima literă majusculă;
4. În câmpul `sex` se va accepta doar valoarea `m` sau `f`;
5. Dacă câmpul name din tabela `X_Grad_Stiintific` nu este completat atunci SGBD implicit va
atribui valoarea "doctor";
6. Pentru câmpul name din tabela `X_Grad_Stiintific` se vor accepta doar valorile: doctor, profesor,
academician;
7. La un câmp să se seteze restricția `UNIQUE`;
8. Să se seteze restricții prin referință pentru înregistrările tabelului `X_Student` și `X_Profesor`, când
se va șterge o înregistrare din tabelul `X_Student` sau `X_Profesor` se vor șterge și înregistrările
referențiate;
9. Creați vederea cu câmpurile: denumirea cursului, numele profesorului care a predat cursul și
numele studenților care au restanță la cursul respectiv;
10. Creați vederea cu câmpurile: numele tuturor profesorilor și tuturor studenților de la facultatea
Matematică și Informatică;
11. Creați vederea cu câmpurile: numele studentului, anul de studii, la ce facultate este student și care
este nota maximă de la examane;
12. Creați vederea cu câmpurile: numele studenților care au examene la profesorul Y.


## Realizarea

> 1\. Setați câmpul `id` ca `PRIMARY KEY` în fiecare tabel.

La mine `id` deja este `primary key` in fiecare tabel, deoarece am setat-o astfel deja în timpul creării.
Însă putem adăuga această restricție prin `alter table`.

```sql
use Universitate
alter table CurmanschiiAnton_Student
add primary key (id)
```

```
Table 'CurmanschiiAnton_Student' already has a primary key defined on it.
```


> 2\. Pentru `nr_credite` să fie acceptate doar valori în diapazonul $ [3-10] $, `nr_ore` $ [20-300] $, `nota` $ [1-10] $, `an_nastere` $ [1980-2000] $, `an_studii` $ [1-4] $.


Am pierdut acest câmp, trebuia să fie inițial în tabelul `CurmanschiiAnton_Curs`.
Îl adaug. L-am pierdut și pe `nr_ore`, îl adaug și pe acesta.

```sql
use Universitate

alter table CurmanschiiAnton_Curs
add nr_credite tinyint not null

alter table CurmanschiiAnton_Curs
add nr_ore tinyint not null
```

Acum adaugăm restricțiile.

```sql
use Universitate

alter table CurmanschiiAnton_Curs
add constraint NrCrediteDiapazon
check (nr_credite >= 3 and nr_credite <= 10)

alter table CurmanschiiAnton_Curs
add constraint NrOreDiapazon
check (nr_ore >= 20 and nr_ore <= 300)

alter table CurmanschiiAnton_Examen
add constraint NotaDiapazon
check (nota >= 1 and nota <= 10)

alter table CurmanschiiAnton_Student
add constraint AnNastereDiapazon
check (year(an_nastere) >= 1980
    and year(an_nastere) <= 2000)

alter table CurmanschiiAnton_Student
add constraint AnStudiiDiapazon
check (an_studii >= 1 and an_studii <= 4)
```


> 3\. Câmpul `nume` și `prenume` să accepte doar litere cu prima literă majusculă.

Aș putea reutiliza funcționalitatea verificării, însă logica este destul de simplă, deci voi lăsa așa.

`collate Latin1_General_CS_AI` înseamnă că șirurile se compar **C**ase-**S**ensitive, **A**ccent-**I**gnore.

Într-um limbaj de programare normal ar arăta mai puțin verboz:
```d
return toUpper(nume[0]) == nume[0];
```

```sql
use Universitate

alter table CurmanschiiAnton_Student
add constraint Nume_PrimaLiteraEsteMajuscula_Student
check (upper(left(nume, 1)) = left(nume, 1) collate Latin1_General_CS_AI)

alter table CurmanschiiAnton_Student
add constraint Prenume_PrimaLiteraEsteMajuscula_Student
check (upper(left(prenume, 1)) = left(prenume, 1) collate Latin1_General_CS_AI)

alter table CurmanschiiAnton_Profesor
add constraint Nume_PrimaLiteraEsteMajuscula_Profesor
check (upper(left(nume, 1)) = left(nume, 1) collate Latin1_General_CS_AI)

alter table CurmanschiiAnton_Profesor
add constraint Prenume_PrimaLiteraEsteMajuscula_Profesor
check (upper(left(prenume, 1)) = left(prenume, 1) collate Latin1_General_CS_AI)
```

> 4\. În câmpul `sex` se va accepta doar valoarea `m` sau `f`.

Sexul poate fi nul, însă check se evaluează la `unknown` dacă valoarea a fost null și **rândul se acceptă** ([sursa](https://dba.stackexchange.com/a/158410)).


```sql
use Universitate

alter table CurmanschiiAnton_Student
add constraint Sex_fm
check (sex in ('m', 'f'))
```

> 5\. Dacă câmpul `nume` din tabela `X_Grad_Stiintific` nu este completat atunci SGBD implicit va atribui valoarea "doctor".

```sql
use Universitate

alter table CurmanschiiAnton_GradStiintific
add constraint NumeImplicitGradStiintific
default 'doctor' for nume
```

> 6\. Pentru câmpul `nume` din tabela `X_Grad_Stiintific` se vor accepta doar valorile: doctor, profesor, academician.

```sql
use Universitate

alter table CurmanschiiAnton_GradStiintific
add constraint NumeGradStiintific_Check
check (nume in ('doctor', 'profesor', 'academician'))
```


> 7\. La un câmp să se seteze restricția `UNIQUE`.

```sql
use Universitate

alter table CurmanschiiAnton_GradStiintific
add unique (nume)
```


> 8\. Să se seteze restricții prin referință pentru înregistrările tabelului `X_Student` și `X_Profesor`, când se va 
> șterge o înregistrare din tabelul `X_Student` sau `X_Profesor` se vor șterge și înregistrările referențiate.


La început trebuie să șterg constrângere foreign key existentă.
Pentru aceasta, voi găsi numele ei în tabloul de sistem:

```sql
use Universitate
select name from sys.objects
where type_desc = 'FOREIGN_KEY_CONSTRAINT' 
    and object_name(parent_object_id) = 'CurmanschiiAnton_CursProfesor'
```

| name                           |
|--------------------------------|
| FK__Curmansch__id_cu__440B1D61 |
| FK__Curmansch__id_pr__44FF419A |

```sql
alter table CurmanschiiAnton_CursProfesor
drop constraint FK__Curmansch__id_pr__44FF419A
```

Acum adaugăm o constrângere deja cu [`on delete cascade`](https://www.sqlshack.com/delete-cascade-and-update-cascade-in-sql-server-foreign-key/), pentru ca să se șteargă după ce obiectul a fost șters în tabelul inițial.


```sql
use Universitate

alter table CurmanschiiAnton_CursProfesor
with check add constraint FK_CursProfesor_IdProfesor
foreign key (id_profesor)
references CurmanschiiAnton_Profesor (id)
on delete cascade
```

Facem același lucru cu tabelele `CurmanschiiAnton_Examen`.

```sql
use Universitate
select name from sys.objects
where type_desc = 'FOREIGN_KEY_CONSTRAINT' 
    and object_name(parent_object_id) = 'CurmanschiiAnton_Examen'
```

| name                           |
|--------------------------------|
| FK__Curmansch__id_cu__47DBAE45 |
| FK__Curmansch__id_pr__48CFD27E |
| FK__Curmansch__id_st__49C3F6B7 |

```sql
alter table CurmanschiiAnton_Examen
drop constraint FK__Curmansch__id_pr__48CFD27E

alter table CurmanschiiAnton_Examen
drop constraint FK__Curmansch__id_st__49C3F6B7
```

```sql
use Universitate

alter table CurmanschiiAnton_Examen
with check add constraint FK_Examen_IdProfesor
foreign key (id_profesor)
references CurmanschiiAnton_Profesor (id)
on delete cascade

alter table CurmanschiiAnton_Examen
with check add constraint FK_Examen_IdStudent
foreign key (id_student)
references CurmanschiiAnton_Student (id)
on delete cascade
```

Și cu `CurmanschiiAnton_CursStudent`

```sql
use Universitate
select name from sys.objects
where type_desc = 'FOREIGN_KEY_CONSTRAINT' 
    and object_name(parent_object_id) = 'CurmanschiiAnton_CursStudent'
```

| name                           |
|--------------------------------|
| FK__Curmansch__id_st__60A75C0F |
| FK__Curmansch__id_cu__619B8048 |
| FK__Curmansch__id_pr__628FA481 |


```sql
alter table CurmanschiiAnton_CursStudent
drop constraint FK__Curmansch__id_pr__628FA481

alter table CurmanschiiAnton_CursStudent
drop constraint FK__Curmansch__id_st__60A75C0F
```

```sql
use Universitate

alter table CurmanschiiAnton_CursStudent
with check add constraint FK_CursStudent_IdProfesor
foreign key (id_profesor)
references CurmanschiiAnton_Profesor (id)
on delete cascade

alter table CurmanschiiAnton_CursStudent
with check add constraint FK_CursStudent_IdStudent
foreign key (id_student)
references CurmanschiiAnton_Student (id)
on delete cascade
```


> 9\. Creați vederea cu câmpurile: denumirea cursului, numele profesorului care a predat cursul și 
> numele studenților care au restanță la cursul respectiv.

[`create view`](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver15).

```sql
create view CursNume_ProfesorNume_StudentNume_Restanta_View
as

select curs.nume as nume_curs, 
       profesor.nume as nume_profesor, 
       student.nume as nume_student

from CurmanschiiAnton_Examen as examen

inner join CurmanschiiAnton_Student as student
on examen.id_student = student.id

inner join CurmanschiiAnton_Profesor as profesor
on examen.id_profesor = profesor.id

inner join CurmanschiiAnton_Curs as curs
on examen.id_curs = curs.id

where examen.nota <= 4
```

> 10\. Creați vederea cu câmpurile: numele tuturor profesorilor și tuturor studenților de la facultatea
> Matematică și Informatică.

Am omis `id_facultate` la student.


```sql
alter table CurmanschiiAnton_Student
add id_facultate int not null 
foreign key references CurmanschiiAnton_Facultate (id)
```

Am realizat aici printr-o interogare imbricată, dar este posibil și prin `inner join`.

```sql
create view NumeProfesor_NumeStudent_MatematicaInformatica_View
as

select student.nume as nume
from CurmanschiiAnton_Student as student

where student.id_facultate = (
    select facultate.id 
    from CurmanschiiAnton_Facultate as facultate
    where facultate.nume = 'Matematica si Informatica')

union all

select profesor.nume as nume
from CurmanschiiAnton_Profesor as profesor

inner join CurmanschiiAnton_CursProfesor as curs_profesor
on curs_profesor.id_profesor = profesor.id

inner join CurmanschiiAnton_Curs as curs
on curs.id = curs_profesor.id_curs

where curs.id_facultate = (
    select facultate.id 
    from CurmanschiiAnton_Facultate as facultate
    where facultate.nume = 'Matematica si Informatica')

```

> 11\. Creați vederea cu câmpurile: numele studentului, anul de studii, la ce facultate este student și care
> este nota maximă de la examene.

```sql
create view NumeStudent_AnStudii_NumeFacultate_NotaMaximaLaExamen_View
as

select student.nume as student_nume,
       student.an_studii,
       facultate.nume as nume_facultate,
       max(examen.nota) as nota_maximala

from CurmanschiiAnton_Student as student

inner join CurmanschiiAnton_Facultate as facultate
on facultate.id = student.id_facultate

inner join CurmanschiiAnton_CursStudent as curs
on curs.id_student = student.id

inner join CurmanschiiAnton_Examen as examen
on examen.id_curs = curs.id_curs
    and examen.id_student = student.id

group by student.nume, student.an_studii, facultate.nume
```


> 12\. Creați vederea cu câmpurile: numele studenților care au examene la profesorul Y.

```sql
create view NumeStudent_ExamenLaProfesor_View
as

select student.nume as student_nume,
       profesor.nume as profesor_nume

from CurmanschiiAnton_Student as student

inner join CurmanschiiAnton_Examen as examen
on examen.id_student = student.id

inner join CurmanschiiAnton_Profesor as profesor
on examen.id_profesor = profesor.id
```


## Verificari

```sql
insert into CurmanschiiAnton_Facultate (id, nume)
values (1, 'Matematica si Informatica')

insert into CurmanschiiAnton_Facultate (id, nume)
values (2, 'Drept')

insert into CurmanschiiAnton_Facultate (id, nume)
values (3, 'Psihologie')

insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    1,
    'Frunza',
    'Ion',
    cast('1999-05-05' as date),
    1,
    'm',
    1)

insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    2,
    'Ion',
    'Ionel',
    cast('1998-06-07' as date),
    1,
    'm',
    2)

insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    3,
    'Ionica',
    'Nica',
    cast('1998-06-07' as date),
    1,
    'm',
    3)

insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    4,
    'Frumoasa',
    'Magdalena',
    cast('1998-06-09' as date),
    1,
    'f',
    1)

-- esueaza
insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    5,
    'a', -- nu este majuscula
    'AA',
    cast('1998-06-09' as date),
    1,
    'f',
    1)

-- esueaza
insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    5,
    'A',
    'AA',
    cast('1998-06-09' as date),
    1,
    'g', -- nu-i 'm' sau 'f'
    1)

-- esueaza
insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    5,
    'A',
    'AA',
    cast('2020-06-09' as date), -- nu-i in interval
    1,
    'f',
    1)

-- esueaza
insert into CurmanschiiAnton_Student (
    id, 
    nume, 
    prenume,
    an_nastere,
    an_studii,
    sex,
    id_facultate)
values (
    5,
    'A',
    'AA',
    cast('1998-06-09' as date),
    0, -- nu-i in interval
    'f',
    1)

insert into CurmanschiiAnton_GradStiintific (id, nume)
values (1, 'doctor')

insert into CurmanschiiAnton_GradStiintific (id, nume)
values (2, 'academician')

insert into CurmanschiiAnton_GradStiintific (id, nume)
values (3, 'ne-doctor') -- esueaza


insert into CurmanschiiAnton_Profesor (
    id, 
    nume,
    prenume,
    id_grad_stiintific)
values (
    1,
    'Ion',
    'Ionica',
    1)

insert into CurmanschiiAnton_Profesor (
    id, 
    nume,
    prenume,
    id_grad_stiintific)
values (
    2,
    'Grigorica',
    'Grigore',
    2)

insert into CurmanschiiAnton_Curs (
    id,
    nume,
    id_facultate,
    nr_credite,
    nr_ore)
values (
    1,
    'curs1',
    1,
    3,
    200)

insert into CurmanschiiAnton_Curs (
    id,
    nume,
    id_facultate,
    nr_credite,
    nr_ore)
values (
    2,
    'curs2',
    2,
    5,
    100)

-- esueaza
insert into CurmanschiiAnton_Curs (
    id,
    nume,
    id_facultate,
    nr_credite,
    nr_ore)
values (
    3,
    'curs2',
    1,
    3,
    10) -- pre putine ore

    
-- esueaza
insert into CurmanschiiAnton_Curs (
    id,
    nume,
    id_facultate,
    nr_credite,
    nr_ore)
values (
    3,
    'curs2',
    1,
    11, -- prea multe credite
    200)


insert into CurmanschiiAnton_Examen (
    id,
    id_curs,
    id_profesor,
    id_student,
    nota)
values (
    1,
    1,
    1,
    1,
    4)

-- esueaza
insert into CurmanschiiAnton_Examen (
    id,
    id_curs,
    id_profesor,
    id_student,
    nota)
values (
    2,
    1,
    1,
    1,
    0) -- prea mica nota

insert into CurmanschiiAnton_Examen (
    id,
    id_curs,
    id_profesor,
    id_student,
    nota)
values (
    3,
    1,
    1,
    2,
    5)

insert into CurmanschiiAnton_Examen (
    id,
    id_curs,
    id_profesor,
    id_student,
    nota)
values (
    4,
    1,
    1,
    3,
    10)

insert into CurmanschiiAnton_Examen (
    id,
    id_curs,
    id_profesor,
    id_student,
    nota)
values (
    5,
    2,
    2,
    1,
    10)

insert into CurmanschiiAnton_CursProfesor (
    id,
    id_curs,
    id_profesor)
values (
    1,
    1,
    1)

insert into CurmanschiiAnton_CursProfesor (
    id,
    id_curs,
    id_profesor)
values (
    2,
    2,
    1)

insert into CurmanschiiAnton_CursStudent (
    id,
    id_student,
    id_curs,
    id_profesor)
values (
    1,
    1,
    1,
    1)

insert into CurmanschiiAnton_CursStudent (
    id,
    id_student,
    id_curs,
    id_profesor)
values (
    2,
    2,
    1,
    1)

insert into CurmanschiiAnton_CursStudent (
    id,
    id_student,
    id_curs,
    id_profesor)
values (
    3,
    1,
    2,
    2)

insert into CurmanschiiAnton_Examen (
    id,
    id_curs,
    id_profesor,
    id_student,
    nota)
values (
    2,
    2,
    2,
    4,
    9)

insert into CurmanschiiAnton_CursStudent (
    id,
    id_curs,
    id_profesor,
    id_student)
values (
    4,
    2,
    1,
    4)
```



```sql
select  * from CursNume_ProfesorNume_StudentNume_Restanta_View
```

|   | nume_curs | nume_profesor | nume_student |
|---|-----------|---------------|--------------|
| 1 | curs1     | Ion           | Frunza       |


```sql
select * from NumeProfesor_NumeStudent_MatematicaInformatica_View
```

|   | nume     |
|---|----------|
| 1 | Frunza   |
| 2 | Frumoasa |
| 3 | Ion      |

```sql
select * from NumeStudent_AnStudii_NumeFacultate_NotaMaximaLaExamen_View
```

|   | student_nume | an_studii | nume_facultate             | nota_maximala |
|---|--------------|-----------|----------------------------|---------------|
| 1 | Frumoasa     | 1         | Matematica  si Informatica | 9             |
| 2 | Frunza       | 1         | Matematica  si Informatica | 10            |
| 3 | Ion          | 1         | Drept                      | 5             |


```sql
select * from NumeStudent_ExamenLaProfesor_View
```

|   | student_nume | profesor_nume |
|---|--------------|---------------|
| 1 | Frunza       | Ion           |
| 2 | Frumoasa     | Grigorica     |
| 3 | Ion          | Ion           |
| 4 | Ionica       | Ion           |
| 5 | Frunza       | Grigorica     |
| 6 | Ionica       | Grigorica     |


### Verificarea ștergerii datorită integrității referențiale


```sql
select * from CurmanschiiAnton_CursStudent
where id_student = 1
go

select * from CurmanschiiAnton_Examen
where id_student = 1
```

| id | id_student | id_curs | id_profesor |
|----|------------|---------|-------------|
| 1  | 1          | 1       | 1           |
| 3  | 1          | 2       | 2           |

| id | id_curs | id_profesor | id_student | nota |
|----|---------|-------------|------------|------|
| 1  | 1       | 1           | 1          | 4    |
| 5  | 2       | 2           | 1          | 10   |

```sql
delete from CurmanschiiAnton_Student
where id = 1
go

select * from CurmanschiiAnton_CursStudent
where id_student = 1
go

select * from CurmanschiiAnton_Examen
where id_student = 1
```

Dau rezultate nule.


```sql
select count(*) from CurmanschiiAnton_CursStudent
where id_profesor = 1
go

select count(*) from CurmanschiiAnton_Examen
where id_profesor = 1
go

select count(*) from CurmanschiiAnton_CursProfesor
where id_profesor = 1
go

-- dau 2, 2, 2

delete from CurmanschiiAnton_Profesor
where id = 1
go


select count(*) from CurmanschiiAnton_CursStudent
where id_profesor = 1
go

select count(*) from CurmanschiiAnton_Examen
where id_profesor = 1
go

select count(*) from CurmanschiiAnton_CursProfesor
where id_profesor = 1
go

-- dau 0, 0, 0
```
