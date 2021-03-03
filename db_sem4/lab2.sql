create type Address_Type as object (
    street 	varchar2(20),
    house 	varchar2(5),
    city 	varchar2(20),
    country varchar2(20)
);
/

create type Client_Type as object(
    id         number(5),
    first_name varchar2(32),
    activity   varchar2(32),
    adress     Address_Type,
    telephone  varchar2(32)
);
/
create table Client_Table of Client_Type (id primary key);
/
create type Client_Reference_Type as ;
/
create type Client_Reference_Table_Type as  Client_Reference_Type;
/

create type Service_Type as object(
    id          number(5),
    name        varchar2(32),
    description varchar2(32)
);
/
create table Service_Table of Service_Type (id primary key);
/
create type Service_Reference_Type as ;
/
create type Service_Reference_Table_Type as table of Service_Reference_Type;
/


create type Transaction_Type as object(
    id          number(5),
    cost        number(4),
    comission   number(4),
    description varchar2(128),
    service_ref          ref Service_Type scope is Service_Table,
    client_nested_table  table of ref Client_Type
);
nested table clients_nested_table store as Transaction_Client_Nested_Reference_Table;
/
create table Transaction_Table of Transaction_Type (id primary key);
/