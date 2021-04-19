-- Facem clean-up inainte de executare a scriptului
drop table Client_Table force;
/
drop table Service_Table force;
/
drop table Promotion_Table force;
/
drop table Transaction_Table force;
/
drop type Address_Type force;
/
drop type Client_Type force;
/
drop type Service_Type force;
/
drop type Promotion_Type force;
/
drop type Transaction_Type force;
/
drop type Client_RT_Type force;
/
drop type Service_RT_Type force;
/
drop type Promotion_RT_Type force;
/

-- Crearea tipului Adresa.
create type Address_Type as object (
    street 	 varchar2(20),
    house 	 varchar2(5),
    city 	 varchar2(20),
    country  varchar2(20)
);
/

-- Crearea tipului Client.
-- Din chestii noi numai faptul ca este obiect si are un camp de tip Adresa.
create type Client_Type as object(
    id          number,
    first_name  varchar2(32),
    activity    varchar2(32),
    adress      Address_Type,
    telephone   varchar2(32)
);
/
-- Pastram inregistrarile dupa al nostru id.
-- Datorite acestei constangeri, oracle nu autogenereaza id-urile.
create table Client_Table of Client_Type (id primary key);
/
-- Tipul Tabel nested de referinte, utilizat ulterior.
create type Client_RT_Type as table of ref Client_Type;
/

-- Crearea tipului Serviciu. Chestia principala — contine costul.
create type Service_Type as object(
    id           number,
    cost         number,
    name         varchar2(32),
    description  varchar2(256)
);
/
create table Service_Table of Service_Type (id primary key);
/
create type Service_RT_Type as table of ref Service_Type;
/

-- Crearea tipului Promotie. Chestia principala — contine discontul.
create type Promotion_Type as object(
    id           number,
    discount     number,
    name         varchar2(32),
    description  varchar2(256)
);
/
create table Promotion_Table of Promotion_Type (id primary key);
/
create type Promotion_RT_Type as table of ref Promotion_Type;
/


-- Crearea tipului Tranzactie
create type Transaction_Type as object(
    id           number,
    comission    number,
    description  varchar2(256),

    -- Tranzactia se face cu un singur client
    client       ref Client_Type,  

    -- La tranzactii se aplica mai multe servicii, care pot sa se repete intre tranzactii
    service_nested_table    Service_RT_Type,
    
    -- La tranzactii se aplica mai multe promotii, care pot sa se repete 
    -- si aplic un discont procentual la intreaga tranzactie
    promotion_nested_table  Promotion_RT_Type,

    -- Aceasta metoda culege costul real al tranzactiei, 
    -- sumand toate serviciile si aplicand promotiile
    member function cost return number
);
/

-- Pastram inregistrarile dupa id-ul nostru si constrangem referintele
create table Transaction_Table of Transaction_Type (
    id primary key,
    scope for (client) is Client_Table
)
-- Cream doua tabele nested de referinte.
nested table service_nested_table store as Transaction_Service_NRT
nested table promotion_nested_table store as Transaction_Promotion_NRT;
/
-- Scope the service table
-- See https://stackoverflow.com/a/66394041/9731532
alter table Transaction_Service_NRT
add scope for (column_value) is Service_Table;
/
alter table Transaction_Promotion_NRT
add scope for (column_value) is Promotion_Table;
/

-- Documentarea la Oracle PL/SQL nu e buna.
-- Mai usor este de scris asa functie eu singur decat s-o caut.
create or replace function Max_Value
(
    a number,
    b number
)
return number
is
begin
    if (a > b) then
        return a;
    else
        return b;
    end if; 
end;
/

create or replace type body Transaction_Type as
    member function cost
        return number 
        is
            v_cost_sum      number;
            v_discount_sum  number;
        begin

            -- Sumarea costurilor
            select sum(deref(value(serv)).cost)
            into v_cost_sum
            from table(service_nested_table) serv;

            -- Sumarea disconturilor
            select sum(deref(value(prom)).discount)
            into v_discount_sum
            from table(promotion_nested_table) prom;

            dbms_output.put_line('Cost:     ' || v_cost_sum);
            dbms_output.put_line('Discount: ' || v_discount_sum);

            -- Limitam valoarea finala la 0
            return Max_Value(v_cost_sum * (1 - v_discount_sum), 0);

        end;
end;
/

-- Functii ajutatoare ca sa nu repetam acest cod in inserari
create or replace function Id_To_Service_Ref
(
    p_id number
)
return ref Service_Type
is
    v_serv_ref ref Service_Type;
begin
    select  ref(serv) 
    into    v_serv_ref
    from    Service_Table serv
    where   id = p_id;

    return v_serv_ref;
end;
/

create or replace function Id_To_Promotion_Ref
(
    p_id number
)
return ref Promotion_Type
is
    v_prom_ref ref Promotion_Type;
begin
    select  ref(prom) 
    into    v_prom_ref
    from    Promotion_Table prom
    where   id = p_id;

    return v_prom_ref;
end;
/

create or replace function Id_To_Client_Ref
(
    p_id number
)
return ref Client_Type
is
    v_client_ref ref Client_Type;
begin
    select  ref(client) 
    into    v_client_ref
    from    Client_Table client
    where   id = p_id;

    return v_client_ref;
end;
/

begin
    -- Inserarea serviciilor
    insert into Service_Table values (1, 350, 'Traducerea in rusa', 'Traducerea actelor din romana in rusa');
    insert into Service_Table values (2, 250, 'Traducerea in poloneza', 'Traducerea actelor din romana in poloneza');
    insert into Service_Table values (3, 200, 'Consultatie', 'Consultatia cu notarul');
    insert into Service_Table values (4, 1000, 'Culegerea actelor (cumparare)', 'Culegerea actelor pentru cumpararea unui apartament');
    insert into Service_Table values (5, 1000, 'Culegerea actelor (vanzare)', 'Culegerea actelor pentru vanzarea unui apartament');

    -- Inserarea promotiilor
    insert into Promotion_Table values (1, 0.2, 'A doua comanda', 'A doua comanda a fiecarui client are 20% discont');
    insert into Promotion_Table values (2, 0.1, 'Client fidel', 'Clientii fideli primesc 10% discont');
    insert into Promotion_Table values (3, 0.1, 'Am deschis!', 'Biroul numai ce s-a deschis, 10% discont la toate servicii');
    insert into Promotion_Table values (4, 1.0, 'Al 10000 client', 'Al 10000 client primeste o deservire gratuita');

    -- Inserarea clientilor
    insert into Client_Table values (1, 'Ion', 'Inotator', Address_Type('str.Stefan', '201', 'Chisinau', 'Moldova'), '123456789'); 
    insert into Client_Table values (2, 'Cucu', 'Taxator', Address_Type('str.Stefan', '211', 'Chisinau', 'Moldova'), '321456789'); 
    insert into Client_Table values (3, 'Vica', 'Inginer', Address_Type('str.Stefan', '22',   'Balti',    'Moldova'), '6969699');
    insert into Client_Table values (4, 'Eugen', 'Pilot',  Address_Type('str.Stefan', '232', 'Ion',      'Romania'), '9696966'); 

    -- Inserarea tranzactiilor
    insert into Transaction_Table values(1, 100, 'Ceva ceva ceva...', 
        Id_To_Client_Ref(1),
        Service_RT_Type(
            Id_To_Service_Ref(1), Id_To_Service_Ref(2), Id_To_Service_Ref(3)
        ),
        Promotion_RT_Type(
            Id_To_Promotion_Ref(3)
        )
    );
    insert into Transaction_Table values(2, 100, 'Tranzactie 2...', 
        Id_To_Client_Ref(2),
        Service_RT_Type(
            Id_To_Service_Ref(2), Id_To_Service_Ref(4), Id_To_Service_Ref(3)
        ),
        Promotion_RT_Type(
            Id_To_Promotion_Ref(3)
        )
    );
    insert into Transaction_Table values(3, 50, 'Tranzactie 2 cu Ion...', 
        Id_To_Client_Ref(1),
        Service_RT_Type(
            Id_To_Service_Ref(1)
        ),
        Promotion_RT_Type(
            Id_To_Promotion_Ref(1), Id_To_Promotion_Ref(2)
        )
    );
    insert into Transaction_Table values(4, 200, 'Ceva ceva ceva...', 
        Id_To_Client_Ref(3),
        Service_RT_Type(
            Id_To_Service_Ref(5)
        ),
        Promotion_RT_Type(
            Id_To_Promotion_Ref(4)
        )
    );
    insert into Transaction_Table values(5, 200, 'Ceva ceva ceva...', 
        Id_To_Client_Ref(4),
        Service_RT_Type(
            Id_To_Service_Ref(5)
        ),
        Promotion_RT_Type()
    );
end;
/

-- Verificam daca functia cost() lucreaza
declare
    v_transaction Transaction_Type;
begin
    select value(t) into v_transaction from Transaction_Table t where id = 1;
    
    -- (350 + 250 + 200) * (1 - 0.1) = 800 * 0.9 = 720
    dbms_output.put_line(v_transaction.cost()); 
end;
/