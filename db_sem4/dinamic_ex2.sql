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
/

create or replace procedure MultiplySalary(employer_id in EMP.EMPNO%type, department_id in EMP.DEPTNO%type, scale in number)
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
