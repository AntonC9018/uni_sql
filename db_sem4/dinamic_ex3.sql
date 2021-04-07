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