create type Address_Type as object (
    street 	 varchar2(20),
    house 	 varchar2(5),
    city 	 varchar2(20),
    country  varchar2(20),
);
/

create type Client_Type as object(
    id          number(5),
    first_name  varchar2(32),
    activity    varchar2(32),
    adress      Address_Type,
    telephone   varchar2(32)
);
/
create table Client_Table of Client_Type (id primary key);
/
create type Client_Reference_Type as ref Client_Type scope is Client_Table;
/
create type Client_Reference_Table_Type as table of Client_Reference_Type;
/

create type Service_Type as object(
    id           number(5),
    -- some other data
    cost         number(4),
    name         varchar2(32),
    description  varchar2(32)
);
/
create table Service_Table of Service_Type (id primary key);
/
create type Service_Reference_Type as ref Service_Type scope is Service_Table;
/
create type Service_Reference_Table_Type as table of Service_Reference_Type;
/

create type Transaction_Type as object(
    id           number(5),
    services     Service_Reference_Table_Type,
    -- some other data
    name         varchar2(32),
    description  varchar2(32)
);
nested table services store as Transaction_Service_Nested_Reference_Table;
/

create type Promotion_Type as object(
    id           number(5),
    discount     number(0, 5),
    name         varchar2(32),
    description  varchar2(32)
);
/
create table Promotion_Table of Promotion_Type (id primary key);
/
create type Promotion_Reference_Type as ref Promotion_Type scope is Promotion_Table;
/
create type Promotion_Reference_Table_Type as table of Promotion_Reference_Type;
/


create type Transaction_Type as object(
    id           number(5),
    comission    number(4),
    description  varchar2(128),
    clients_nested_table    Client_Reference_Table_Type,
    service_nested_table    Service_Reference_Table_Type,
    promotion_nested_table  Promotion_Reference_Table_Type,

    member function cost return number;
);
nested table clients_nested_table store as Transaction_Client_Nested_Reference_Table;
/
nested table service_nested_table store as Transaction_Service_Nested_Reference_Table;
/
nested table promotion_nested_table store as Transaction_Promotion_Nested_Reference_Table;
/


create type body Transaction_Type as
    member function cost
        return number 
        is
            v_cost_sum      number,
            v_discount_sum  number
        begin
            select sum(deref(serv).cost)
            into v_cost_sum
            from service_nested_table serv;

            select sum(deref(disc).discount)
            into v_discount_sum
            from discount_nested_table disc;

            if (v_discount_sum > 1) then
                v_discount_sum = 1;
            end if;

            return v_cost_sum * (1 - v_discount_sum);
        end;
end;



create table Transaction_Table of Transaction_Type (id primary key);
/