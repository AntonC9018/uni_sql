Tema: **SQL dinamic**.
Student: **Curmanschii Anton, IA1901**.

## Exercitiu 2.

Fie schema `SCOTT` cu tabela `EMP`.
De creat o instrucțiune dinamică pentru modificarea (`UPDATE`) salariului salariatului cu codul (câmpul `EMPNO`) X din secția (câmpul `DEPTNO`) Y. Salariul trebuie de majorat cu Z procente și de returnat suma ( pe câmpul `SAL`) modificată (`RETURNING`).
Afișați aceasta valoare.


Am realizat o variantă fără SQL dinamic.

```sql
create or replace procedure MultiplySalary(employer_id in EMP.EMPNO%type, department_id in EMP.DEPTNO%type, scale in EMP.SAL%type)
    is 
        new_salary EMP.SAL%type;
    begin
        update EMP
        set    SAL = SAL * scale
        where  EMPNO = employer_id and DEPTNO = department_id
        returning SAL into new_salary;

        dbms_output.put_line(new_salary);
        
    end MultiplySalary;
/
begin
    MultiplySalary(7369, 20, 1.2);
end;
```

Acum o traducem în SQL dinamic. La început nu puteam să mă descurc de ce nu lucrează.
1. Bindam variabilele separat
2. Bindam variabila out printr-un argument pozițional
3. Bindam variabila out într-o clauză `returning into`

Însă problema a fost că șirul de comanda sql nu trebuie să conțină `;` la sfârșit. 

```sql
create or replace procedure MultiplySalary(employer_id in EMP.EMPNO%type, department_id in EMP.DEPTNO%type, scale in EMP.SAL%type)
    is 
        new_salary EMP.SAL%type;
        sql_string varchar2(200);
    begin
        sql_string := 
            'update EMP'        ||
            ' set SAL = SAL * ' || scale         ||
            ' where EMPNO = '   || employer_id   ||
            ' and DEPTNO = '    || department_id ||
            ' returning SAL into :new_salary';

        execute immediate sql_string using out new_salary;

        dbms_output.put_line(new_salary);
        
    end MultiplySalary;
/
begin
    MultiplySalary(7369, 20, 1.2);
end;
```


## Exercitiu 3.

Fie schema `SCOTT` cu tabela `EMP`. De selectat informația din tabela `EMP` folosind variabile tip cursor 
slab și puternic tipizate. 


Acest cod nu va lucra.

```sql
declare
    type Emp_Cursor_Type   is ref cursor return EMP%rowtype;
    type Salary_Table_Type is table of EMP.SAL%type;
    type EName_Table_Type  is table of EMP.ENAME%type;
    emp_cursor   Emp_Cursor_Type;
    salary_table Salary_Table_Type;
    name_table   EName_Table_Type;
begin
    open emp_cursor for select SAL, ENAME from EMP;
    fetch emp_cursor bulk collect into salary_table, name_table;

    for i in salary_table.first .. salary_table.last
    loop
        dbms_output.put_line('The guy ' || name_table(i) || ' has salary ' || salary_table(i)); 
    end loop;

    close emp_cursor;
end;
```

Aparent, `open emp_cursor for select SAL, ENAME from EMP;` nu este posibil de folosit cu altceva decât * în select.

Putem schimba acest rând la `open emp_cursor for select * from EMP;`, dar atunci vom selecta datele de care nu avem nevoie și nu vom putea să selectăm doar cele două câmpuri necesare din acest cursor. Am putea mai defini câte un tip și câte o tabelă de acel tip pentru fiecare câmp din tabela `EMP`, însă aceasta nu e practic.

Nu știu dacă este posibil de definit un cursor tipizat care să conțină un tuplu de date, de mai multe tipuri.

Încă, acest ar lucra dacă am selecta doar un singur câmp, însă așa ceva nu este posibil: trebuie numaidecât să selectăm deodată întreaga coloană (eroarea `invalid cursor return type; 'EMP.SAL%TYPE' must be a record type`):

```sql
declare
    type Emp_Cursor_Type   is ref cursor return EMP.SAL%type; -- must be a record type!
    type Salary_Table_Type is table of EMP.SAL%type;
    emp_cursor   Emp_Cursor_Type;
    salary_table Salary_Table_Type;
begin
    open emp_cursor for select SAL from EMP;
    fetch emp_cursor bulk collect into salary_table;

    for i in salary_table.first .. salary_table.last
    loop
        dbms_output.put_line('Salary: ' || salary_table(i)); 
    end loop;

    close emp_cursor;
end;
```

Va lucra numai acel cod, unde noi selectăm toată informație din cursor într-o variabilă de tipul întregului rând.

```sql
declare
    type Emp_Cursor_Type is ref cursor return EMP%rowtype;
    type Emp_Table_Type  is table of EMP%rowtype;
    emp_cursor Emp_Cursor_Type;
    emp_table  Emp_Table_Type;
begin
    open emp_cursor for select * from EMP;
    fetch emp_cursor bulk collect into emp_table;

    for i in emp_table.first .. emp_table.last
    loop
        dbms_output.put_line('The guy ' || emp_table(i).ENAME || ' has salary ' || emp_table(i).SAL); 
    end loop;

    close emp_cursor;
end;
```

```
The guy SMITH has salary 2866.55
The guy ALLEN has salary 1600
The guy WARD has salary 1250
The guy JONES has salary 2975
The guy MARTIN has salary 1250
The guy BLAKE has salary 2850
The guy CLARK has salary 2450
The guy SCOTT has salary 3000
The guy KING has salary 5000
The guy TURNER has salary 1500
The guy ADAMS has salary 1100
The guy JAMES has salary 950
The guy FORD has salary 3000
The guy MILLER has salary 1300
```

Însă cu un cursor netipizat putem selecta ce vrem. Deci, așa cod lucrează:

```sql
declare
    type Emp_Cursor_Type   is ref cursor;
    type Salary_Table_Type is table of EMP.SAL%type;
    type EName_Table_Type  is table of EMP.ENAME%type;
    emp_cursor   Emp_Cursor_Type;
    salary_table Salary_Table_Type;
    name_table   EName_Table_Type;
begin
    open emp_cursor for select SAL, ENAME from EMP;
    fetch emp_cursor bulk collect into salary_table, name_table;

    for i in salary_table.first .. salary_table.last
    loop
        dbms_output.put_line('The guy ' || name_table(i) || ' has salary ' || salary_table(i)); 
    end loop;

    close emp_cursor;
end;
```