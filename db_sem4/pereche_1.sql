create or replace type Address_Type as object
(
    street      VARCHAR2(30),
    city        VARCHAR2(20),
    state       CHAR(2),
    postal_code VARCHAR2(6)
);
/

create or replace type Employee_Type as object
(
    employee_id     NUMBER(6),
    first_name      VARCHAR2(20),
    last_name       VARCHAR2(25),
    email           VARCHAR2(25),
    phone_number    VARCHAR2(20),
    hire_date       DATE,
    job_id          VARCHAR2(10),
    salary          NUMBER(8,2),
    commission_pct  NUMBER(2,2),
    manager_id      NUMBER(6),
    department_id   NUMBER(4),
    address         Address_Type,
    MAP MEMBER FUNCTION get_idno RETURN NUMBER,
    MEMBER PROCEDURE display_address (SELF IN OUT NOCOPY Employee_Type)
);
/

create type body Employee_Type as
    MAP MEMBER FUNCTION get_idno return number is
    begin
        return employee_id;
    end;
    /* Self in out nocopy means pass by reference */ 
    MEMBER PROCEDURE display_address (self in out nocopy Employee_Type) is
    begin
        dbms_output.put_line(first_name || ' ' || last_name);
        dbms_output.put_line(address.street);
        dbms_output.put_line(address.city || ', ' || address.state || ' ' ||address.postal_code);
    end;
end;
/

create table Employee_Table of Employee_Type;
/

insert into Employee_Table values Employee_Type(
    1, 'Ion', 'Ion', 'hello', '123123123', 
    to_date('13/01/2021', 'dd/mm/yyyy'), 'hello', 123, 1.1, 1, 1, 
    Address_Type('str.Ion', 'Ion', '12', '123123'));