# SGBD Laborator nr.1.

A realizat: **Curmanschii Anton, IA1901**.

## Sarcinile + Raspunsurile

1. Creați un cont Apex.oracle.com.

2. Conectați-vă.

3. Revedeți tot materialul de la cursul anterior al bazei de date folosind tutorialul
https://www.tutorialspoint.com/plsql/plsql_online_test.htm

4. Rezolvati următoarele sarcini pentru a consolida materialul acoperit.


- Creați un bloc anonim în care sunt multiplicate două variabile, două constante și rezultatul este dat.

```sql
declare
    a int;
    b float;
    c constant float := 3.1415; 
    d constant int := 5;
begin
    a := 1;
    b := 2.0;
    dbms_output.put_line('a * b = ' || a * b);
    dbms_output.put_line('c * d = ' || c * d);
end;
```

- Variabile de tip numeric, șir de caractere, dată calendaristica.

```sql
a number(5, 2); /* Un numar de sub forma 12345.67 */
b varchar2(5);  /* Un sir de caractere, lungimea maxima = 5 */
c date := to_date('13/01/2021', 'dd/mm/yyyy');
```

- Creați un bloc în care sunt declarate procedurile pentru adăugarea a două variabile (a, b) și scăderea a două variabile. A și b parametrii IN, c parametrul out. Apelați-l în corpul blocului și imprimați rezultatele.

```sql
declare
    x number;
    y number;
    z number;
procedure add_
    (a in number, b in number, c out number)
is
begin
    c := a + b;
end;
procedure sub_
    (a in number, b in number, c out number)
is
begin
    c := a - b;
end;
begin
    x := 1;
    y := 2;
    add_(x, y, z);
    dbms_output.put_line('x + y = ' || z);
    sub_(x, y, z);
    dbms_output.put_line('x - y = ' || z);
end;
```

- Creați proceduri stocate pentru adăugarea, ștergerea, înmulțirea și împărțirea a două numere (a, b).
Apelați și tipăriți rezultatele. În procedura de împărțire, gestionați situația de împărțire la zero în trei moduri:
    - Utilizarea operatorului IF
    - Cu excepție încorporată
    - Utilizarea excepției personalizate

```sql
declare
    x number;
    y number;
    z number;
create or replace procedure add_
    (a in number, b in number, c out number)
as
begin
    c := a + b;
end;

create or replace procedure sub_
    (a in number, b in number, c out number)
as
begin
    c := a - b;
end;
create or replace procedure mul_
    (a in number, b in number, c out number)
as
begin
    c := a * b;
end;

/* Se emite o exceptie automat */
create or replace procedure div_
    (a in number, b in number, c out number)
as
begin
    c := a / b;
exception
    when zero_divide then
        dbms_output.put_line('WARNING: divizarea la zero.');
        c := 0;
end;

/* Returnam de ex. 0 daca se divizeaza la 0 */
create or replace procedure div_zero_check
    (a in number, b in number, c out number)
as
begin
    if (b != 0) then
        c := a / b;
    else
        dbms_output.put_line('WARNING: divizarea la zero.');
        c := 0;
    end if;
end;

/* Emitem o exceptie noi */
create or replace procedure div_our_exception
    (a in number, b in number, c out number)
as
division_by_zero exception;
begin
    if (b = 0) then
        raise division_by_zero;
    c := a / b;
    end if;
exception
    when division_by_zero then
        dbms_output.put_line('WARNING: divizarea la zero.');
        c := 0;
end;

declare
    x number;
    y number;
    z number;
begin
    x := 1;
    y := 2;
    add_(x, y, z);
    dbms_output.put_line('x + y = ' || z);
    sub_(x, y, z);
    dbms_output.put_line('x - y = ' || z);
    mul_(x, y, z);
    dbms_output.put_line('x * y = ' || z);
    div_(x, y, z);
    dbms_output.put_line('x / y = ' || z);

    y := 0;
    div_(x, y, z);
    dbms_output.put_line('1  x / y = ' || z);
    div_zero_check(x, y, z);
    dbms_output.put_line('2  x / y = ' || z);
    div_our_exception(x, y, z);
    dbms_output.put_line('3  x / y = ' || z);
end;
```

```
x + y = 3
x - y = -1
x * y = 2
x / y = .5
WARNING: divizarea la zero.
1  x / y = 0
WARNING: divizarea la zero.
2  x / y = 0
WARNING: divizarea la zero.
3  x / y = 0
```

- Creați un tabel Student 

```sql
create table Student(id int, varsta int, nume varchar2(32)); 
```

- Completați rânduri

```sql
insert into Student(id, varsta, nume) values(1, 15, 'Ion');
insert into Student(id, varsta, nume) values(2, 14, 'Ionel');
insert into Student(id, varsta, nume) values(3, 19, 'Vasile');
insert into Student(id, varsta, nume) values(4, 18, 'Eugen');
insert into Student(id, varsta, nume) values(5, 16, 'Ion');
insert into Student(id, varsta, nume) values(6, 17, 'Ion');
```

- Faceți o selecție dintr-un tabel

```sql
select * from Student where varsta > 16
```

- Repetați funcțiile grupului într-un bloc anonim: câți studenți, scorul mediu pentru grupuri, cel mai mare scor, care este numele elevului cu cel mai mare scor

```sql
/* adaugam info despre grupa in tabel */
alter table Student add grupa int default 1;
update Student set grupa = 2 where varsta > 15;

/* adaugam info despre scor in tabel */
alter table Student add scor int default 5;
update Student set scor = 6 where id < 4;
update Student set scor = 7 where nume = 'Ion';


create or replace function CountStudents
return int is 
    v_count int;
begin
    select count(id) into v_count from Student;
    return v_count;
end;

create or replace function GroupAverageScore(v_grupa int)
return number is 
    v_scor number;
begin
    select avg(scor) into v_scor from Student where grupa = v_grupa;
    return v_scor;
end;

create or replace function GroupHighestScore(v_grupa int)
return int is 
    v_scor int;
begin
    select max(scor) into v_scor from Student where grupa = v_grupa;
    return v_scor;
end;

create or replace function NameOfStudent_WithHighestScore
return varchar2 is 
    v_nume varchar2(32);
begin
    select nume into v_nume from Student 
        where scor = (select max(scor) from Student)
        and rownum <= 1
        order by id asc;
    return v_nume;
end;
```

- Stabiliți dacă a fost făcută o actualizare și de câte ori

```sql
create or replace procedure Actualizare
is
    total_rows number;
begin
    update Student set varsta = varsta + 1;
    if sql%notfound then 
      dbms_output.put_line('no students updated'); 
    elsif sql%found then
        total_rows := sql%rowcount;
        dbms_output.put_line( total_rows || ' students updated'); 
    end if;
end;  
```

Pornim cu 
```sql
begin
    Actualizare();
end;
```

```
6 students updated
```

- Creați un cursor care selectează date din tabelul Student.

```sql
declare 
    s_id Student.id%type; 
    s_nume Student.nume%type; 
    s_grupa Student.grupa%type;

    cursor c_student is 
        select id, nume, grupa from Students; 
begin 
    /* Se afiseaza toti studentii */
    open c_student; 
    loop 
    fetch c_student into s_id, s_nume, s_grupa; 
        exit when c_student%notfound; 
        dbms_output.put_line(s_id || ' ' || s_nume || ' ' || s_grupa); 
    end loop; 
    close c_student; 

    /* Gasim studentul particular. Sau spunem, cu numele Ion */
    open c_student;
    loop
    fetch c_student into s_id, s_nume, s_grupa;
        if c_student%notfound
            dbms_output.put_line('Student Ion has not been found'); 
            exit;
        elsif s_nume = 'Ion'
            dbms_output.put_line('Student Ion: id = ' || s_id || ', grupa = ' || s_grupa); 
            exit;
        end if;
    end loop;
    close c_student;
end; 
```

- Repetați acest lucru cu excepții.

```sql
create or replace procedure PrintStudent
    (v_nume varchar2)
as
    s_id Student.id%type; 
    s_nume Student.nume%type; 
    s_grupa Student.grupa%type;

    cursor c_student is 
        select id, nume, grupa from Student; 
    student_not_found exception;
begin
    open c_student;
    loop
    fetch c_student into s_id, s_nume, s_grupa;
        if c_student%notfound then
            raise student_not_found;
            exit;
        elsif s_nume = v_nume then
            dbms_output.put_line('Student ' || v_nume || ': id = ' || s_id || ', grupa = ' || s_grupa); 
            exit;
        end if;
    end loop;
    close c_student;
exception
    when student_not_found then
        dbms_output.put_line('Student ' || v_nume || ' has not been found');
end;
```

- Adăugați un rând in tabela, dacă există mai mult de n înregistrări, anulați operațiunea (tranzacția)
Verificați (câte înregistrări sunt în tabel).

```sql
declare
    num_students number;
begin
    savepoint save1;
    insert into Student(id, varsta, nume, grupa, scor) values (7, 15, 'Ion', 3, 8);
    select count(id) into num_students from Student;

    if num_students > 6 then
        rollback to save1;
    else
        commit;
    end if;
end;
```

- Creați un declanșator care efectuează această verificare.

```sql
create or replace trigger max_out_at_6 
before insert on Student 
for each row 
declare
    num_students number;
    too_many_students exception;
begin
    select count(id) into num_students from Student;
    if num_students >= 6 then
        dbms_output.put_line('Max number of students is 6.');
        raise too_many_students;
    end if;
end;
```

Inseram cu:

```sql
insert into Student(id, varsta, nume, grupa, scor) values (7, 15, 'Ion', 3, 8);
```

Dupa executarea, vedem eroarea in consola:

```sql
PL/SQL: unhandled user-defined exception
```

Putem verifica numarul de studenti cu:

```sql
select * from Student
```