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

Aș putea reutiliza funcționalitatea verificării, însă logica este destul de trivială, deci voi lăsa așa.

```sql
use Universitate

alter table CurmanschiiAnton_Student
add constraint Nume_PrimaLiteraEsteMajuscula_Student
check (upper(left(nume, 1)) = left(nume, 1))

alter table CurmanschiiAnton_Student
add constraint Prenume_PrimaLiteraEsteMajuscula_Student
check (upper(left(prenume, 1)) = left(prenume, 1))

alter table CurmanschiiAnton_Profesor
add constraint Nume_PrimaLiteraEsteMajuscula_Profesor
check (upper(left(nume, 1)) = left(nume, 1))

alter table CurmanschiiAnton_Profesor
add constraint Prenume_PrimaLiteraEsteMajuscula_Profesor
check (upper(left(prenume, 1)) = left(prenume, 1))
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

???


> 9\. Creați vederea cu câmpurile: denumirea cursului, numele profesorului care a predat cursul și 
> numele studenților care au restanță la cursul respectiv.

[`create view`](https://docs.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver15).

```sql
use Universitate
go

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

Am omis id_facultate la student.


```sql
alter table CurmanschiiAnton_Student
add id_facultate int not null 
foreign key references CurmanschiiAnton_Facultate (id)
```


```sql
use Universitate
go

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

> 11. Creați vederea cu câmpurile: numele studentului, anul de studii, la ce facultate este student și care
> este nota maximă de la examane.


> 12. Creați vederea cu câmpurile: numele studenților care au examene la profesorul Y.
