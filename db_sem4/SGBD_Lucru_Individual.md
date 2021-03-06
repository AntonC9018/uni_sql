# Lucru Individual la SGBD

A efectuat: **Curmanschii Anton, IA1901**.

Varianta 7, **Biroul notarial**.

## Sarcina

### Descrierea zonei de subiect.

Lucrezi într-un birou notarial. Sarcina ta este de a monitoriza partea financiară a companiei.
Activitățile biroului notarial sunt organizate după cum urmează: compania este gata să ofere clientului o anumită gamă de servicii. Pentru a restabili comanda, ați oficializat aceste servicii compunând o listă cu o descriere a fiecărui serviciu. Când un client te contactează, datele sale standard (nume, tip de activitate, adresă, telefon) sunt înregistrate în baza de date. Un document este pregătit pentru fiecare faptă a furnizării serviciilor către client. Documentul indică serviciul, valoarea tranzacției, comisionul (venitul biroului), descrierea tranzacției.
tabele
```
Clienți (cod client, nume, tip de activitate, adresă, telefon).
Tranzacții (Codul tranzacției, Codul clientului, Codul serviciului, Suma, Comisia, Descrierea).
Servicii (Cod Service, Nume, Descriere).
```

### Dezvoltarea enunțului de probleme

Acum situația s-a schimbat. În cadrul unei tranzacții, unui client i se poate oferi mai multe servicii. Costul fiecărui serviciu este fix. În plus, compania oferă diverse tipuri de reduceri într-o singură tranzacție. Reduceri pot fi adăugate.
Faceți modificări la structura tabelului care ține cont de aceste date și modificați interogările existente. Adăugați întrebări noi.

## Codul 

```sql
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
drop type Client_Reference_Table_Type force;
/
drop type Service_Reference_Table_Type force;
/
drop type Promotion_Reference_Table_Type force;
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
create type Client_Reference_Table_Type as table of ref Client_Type;
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
create type Service_Reference_Table_Type as table of ref Service_Type;
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
create type Promotion_Reference_Table_Type as table of ref Promotion_Type;
/


-- Crearea tipului Tranzactie.
create type Transaction_Type as object(
    id           number,
    comission    number,
    description  varchar2(256),

    -- Tranzactia se face cu un singur client.
    client       ref Client_Type,  

    -- La tranzactii se aplica mai multe servicii, care pot sa se repete intre tranzactii.
    service_nested_table    Service_Reference_Table_Type,
    
    -- La tranzactii se aplica mai multe promotii, care pot sa se repete.
    -- Ele aplica un discont procentual la intreaga tranzactie.
    promotion_nested_table  Promotion_Reference_Table_Type,

    -- Aceasta metoda culege costul real al tranzactiei, 
    -- sumand toate serviciile si aplicand promotiile.
    member function cost return number
);
/

-- Pastram inregistrarile dupa id-ul nostru si constrangem referintele.
create table Transaction_Table of Transaction_Type (
    id primary key,
    scope for (client) is Client_Table
)
-- Cream doua tabele nested de referinte.
nested table service_nested_table store as Transaction_Service_Nested_Reference_Table
nested table promotion_nested_table store as Transaction_Promotion_Nested_Reference_Table;
/
-- Scope the service table
-- See https://stackoverflow.com/a/66394041/9731532
alter table Transaction_Service_Nested_Reference_Table
add scope for (column_value) is Service_Table;
/
alter table Transaction_Promotion_Nested_Reference_Table
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

            -- Sumarea costurilor.
            select sum(deref(value(serv)).cost)
            into v_cost_sum
            from table(service_nested_table) serv;

            -- Sumarea disconturilor.
            select sum(deref(value(prom)).discount)
            into v_discount_sum
            from table(promotion_nested_table) prom;

            dbms_output.put_line('Cost:     ' || v_cost_sum);
            dbms_output.put_line('Discount: ' || v_discount_sum);

            -- Limitam valoarea finala la 0.
            return Max_Value(v_cost_sum * (1 - v_discount_sum), 0);

        end;
end;
/

-- Functii ajutatoare ca sa nu repetam acest cod in inserari.
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
    -- Inserarea serviciilor.
    insert into Service_Table values (1, 350, 'Traducerea in rusa', 'Traducerea actelor din romana in rusa');
    insert into Service_Table values (2, 250, 'Traducerea in poloneza', 'Traducerea actelor din romana in poloneza');
    insert into Service_Table values (3, 200, 'Consultatie', 'Consultatia cu notarul');
    insert into Service_Table values (4, 1000, 'Culegerea actelor (cumparare)', 'Culegerea actelor pentru cumpararea unui apartament');
    insert into Service_Table values (5, 1000, 'Culegerea actelor (vanzare)', 'Culegerea actelor pentru vanzarea unui apartament');

    -- Inserarea promotiilor.
    insert into Promotion_Table values (1, 0.2, 'A doua comanda', 'A doua comanda a fiecarui client are 20% discont');
    insert into Promotion_Table values (2, 0.1, 'Client fidel', 'Clientii fideli primesc 10% discont');
    insert into Promotion_Table values (3, 0.1, 'Am deschis!', 'Biroul numai ce s-a deschis, 10% discont la toate serviciile');
    insert into Promotion_Table values (4, 1.0, 'Al 10000 client', 'Al 10000 client primeste o deservire gratuita');

    -- Inserarea clientilor.
    insert into Client_Table values (1, 'Ion', 'Inotator', Address_Type('str.Stefan', '201', 'Chisinau', 'Moldova'), '123456789'); 
    insert into Client_Table values (2, 'Cucu', 'Taxator', Address_Type('str.Stefan', '211', 'Chisinau', 'Moldova'), '321456789'); 
    insert into Client_Table values (3, 'Vica', 'Inginer', Address_Type('str.Stefan', '22',   'Balti',    'Moldova'), '6969699');
    insert into Client_Table values (4, 'Eugen', 'Pilot',  Address_Type('str.Stefan', '232', 'Ion',      'Romania'), '9696966'); 

    -- Inserarea tranzactiilor.
    insert into Transaction_Table values(1, 100, 'Ceva ceva ceva...', 
        Id_To_Client_Ref(1),
        Service_Reference_Table_Type(
            Id_To_Service_Ref(1), Id_To_Service_Ref(2), Id_To_Service_Ref(3)
        ),
        Promotion_Reference_Table_Type(
            Id_To_Promotion_Ref(3)
        )
    );
    insert into Transaction_Table values(2, 100, 'Tranzactie 2...', 
        Id_To_Client_Ref(2),
        Service_Reference_Table_Type(
            Id_To_Service_Ref(2), Id_To_Service_Ref(4), Id_To_Service_Ref(3)
        ),
        Promotion_Reference_Table_Type(
            Id_To_Promotion_Ref(3)
        )
    );
    insert into Transaction_Table values(3, 50, 'Tranzactie 2 cu Ion...', 
        Id_To_Client_Ref(1),
        Service_Reference_Table_Type(
            Id_To_Service_Ref(1)
        ),
        Promotion_Reference_Table_Type(
            Id_To_Promotion_Ref(1), Id_To_Promotion_Ref(2)
        )
    );
    insert into Transaction_Table values(4, 200, 'Ceva ceva ceva...', 
        Id_To_Client_Ref(3),
        Service_Reference_Table_Type(
            Id_To_Service_Ref(5)
        ),
        Promotion_Reference_Table_Type(
            Id_To_Promotion_Ref(4)
        )
    );
    insert into Transaction_Table values(5, 200, 'Ceva ceva ceva...', 
        Id_To_Client_Ref(4),
        Service_Reference_Table_Type(
            Id_To_Service_Ref(5)
        ),
        Promotion_Reference_Table_Type()
    );
end;
/

-- Verificam daca functia cost() lucreaza.
declare
    v_transaction Transaction_Type;
begin
    select value(t) into v_transaction from Transaction_Table t where id = 1;
    
    -- (350 + 250 + 200) * (1 - 0.1) = 800 * 0.9 = 720.
    dbms_output.put_line(v_transaction.cost()); 
end;
/
```

## Sarcinile actualizate.

Am bifat sarcinile pe care le-am atins în cadrul lucrării precedente, cele nebifate rămâne să le realizez.

Restul acestui document va conține punctele acestea, realizate unu câte unu. Dacă nu văd aplicații pentru una dintre metode pentru baza de date a mea, voi născoci un exemplu funcționar pentru a demonstra că cunosc acea temă.

<div class="ticks" markdown="1">

- [x] De creat baza de date obiectuală individuală.  
- [x] De creat tipurile.  
- [x] De creat tabele obiectuale.  
- [x] De creat legături între entități.  
- [ ] Păstrare obiecte - colonițe (atribute). Adică de făcut o tabelă cu tip obiect printre alte date.  
    - [ ] înserare;  
    - [ ] selectare.  
- [ ] Păstrare atribute de tip colecții:  
    - [x] table;  
        - [x] înserare;  
        - [x] selectare. (am folosit selectarea în funcția `cost()`)  
    - [ ] varray.  
        - [ ] înserare;  
        - [ ] selectare.  
- [ ] De aplicat operația `BULK`.  
- [ ] De creat o ierarhie de tipuri:  
    - [ ] overload;  
    - [ ] overriding;  
    - [ ] selectare.  
- [ ] De aplicat diferite metode de selectare a datelor:  
    - [x] `VALUE`;  
    - [x] `DEREF`;  
    - [ ] `IS OF`.  

</div>

## Păstrare obiecte - colonițe

Nu am idei cum să incorporez ideea dată în bază de date care deja am, deci voi demonstra printr-un exemplu. 

Zicem, avem un astfel de tip de persoană:
```sql
create type Person_Type as object(
    first_name  varchar2(32),
    last_name  varchar2(32)
);
```

Putem crea un tabel, unde vom păstra aceste persoane pe lângă, zicem, adresa lor și numărul de telefon al lor, astfel:
```sql
create table Person_Mixed_Table (
    person Person_Type, 
    address Address_Type,
    telephone varchar2(32)
);
```

Pentru înserări folosim direct constructorii:
```sql
insert into Person_Mixed_Table(person, address, telephone) 
values (
    Person_Type('Ion', 'Guguta'),
    Address_Type('str.Stefan', '123', 'Chisinau', 'MD'),
    '123123123'
);
```

Sau variabile temporare într-un bloc anonim:
```sql
declare
    v_person Person_Type;
    v_address Address_Type;
    v_telephone varchar2(32);
begin
    v_person := Person_Type('Ion', 'Guguta');
    v_address := Address_Type('str.Stefan', '123', 'Chisinau', 'MD');
    v_telephone := '123123123';
    
    insert into Person_Mixed_Table(person, address, telephone) 
    values (v_person, v_address, v_telephone);
end;
```

Selectăm numele persoanelor cu prenumele Ion (afișează Guguta de 2 ori):
```sql
select t.person.last_name
    from Person_Mixed_Table t
    where t.person.first_name = 'Ion';
```

Facem același lucru într-un bloc PL/SQL, doar că luăm numai o singură persoană:
```sql
declare 
    v_person Person_Type;
begin
    select t.person
        into v_person
        from Person_Mixed_Table t
        where t.person.first_name = 'Ion' 
        -- luam doar o persoana
        and rownum <= 1;

    dbms_output.put_line(v_person.last_name);
end;
```

## Păstrare atribute de tip colecții

Deja am păstrat date în tabele nested, rămâne să exemplific varray-urile.

Diferența între varray-uri și tabele nested este următoarea: tabele nested sunt traduse într-o tabelă normală, comună pentru toate înregistrările tipului care declară acea tabelă. Implicit, este utilizată tabela care leagă id-ul înregistrării cu tip de date specificat. Însă, varray-urile păstrează datele pe lângă altor date, în spațiul de memorie alocat pentru acea înregistrare ([cu unele condiții](https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/05_colls.htm), căutați `4KB`. Nu pot linka la locul concret, deoarece el nu are id).

Zicem, persoana noastră acum poate avea până la 5 numere de telefon:
```sql
create type Telephone_Varray as varray(5) of varchar2(32);
/
create table Person_Mixed_Table (
    person Person_Type, 
    address Address_Type,
    telephones Telephone_Varray
);
```

Vom introduce 2 înregistrări: una cu 3 numere de telefon, alta fără nici un număr de telefon:
```sql
insert into Person_Mixed_Table(person, address, telephones) 
values (
    Person_Type('Ion', 'Guguta'),
    Address_Type('str.Stefan', '123', 'Chisinau', 'MD'),
    Telephone_Varray('123123123', '1234567', '123123')
);
/

insert into Person_Mixed_Table(person, address, telephones) 
values (
    Person_Type('Grigore', 'Ursu'),
    Address_Type('str.Stefan', '231', 'Balti', 'Romania'),
    Telephone_Varray()
);
/
```

Putem selecta elemente într-o variabilă locală, ca și cu tabele nested. De exemplu, acest cod va afișa toate numerele de telefon lui Ion (fiind dat faptul că există numai un Ion în tabelă):
```sql
declare
    ion_telephones Telephone_Varray;
begin
    select t.telephones
        into ion_telephones
        from Person_Mixed_Table t
        where t.person.first_name = 'Ion';
    
    for i in ion_telephones.first .. ion_telephones.last
    loop
        dbms_output.put_line(i);
        dbms_output.put_line(ion_telephones(i));
    end loop;
end;
```

Acest cod, de exemplu, va schimba ultimul număr de telefon lui Ion la valoarea `000`:
```sql
declare
    ion_telephones Telephone_Varray;
begin
    select t.telephones
        into ion_telephones
        from Person_Mixed_Table t
        where t.person.first_name = 'Ion';
    
    ion_telephones(ion_telephones.last) := '000';

    update Person_Mixed_Table t
        set t.telephones = ion_telephones
        where t.person.first_name = 'Ion';
end;
```

Putem să ne asigurăm în această, pornind încă o dată codul pentru printare.


## Operația `bulk`

Operația bulk permite să selectăm mai multe înregistrări dintr-o tabelă într-o variabilă locală de tip table.

Zicem, că aș dori să selectăm primele 3 tranzacții din tabela de tranzacții și să le adăugăm câte 100 la valoarea comisiei:
```sql
create type Transaction_Table_Type as table of Transaction_Type;
/

declare
    v_transactions Transaction_Table_Type;
    
    -- Cursorul explicit este necesar pentru a stabili limita de 3
    cursor transaction_cursor is 
        select value(t)
        from Transaction_Table t;
begin
    open transaction_cursor;

    -- Utilizarea lui bulk collect
    fetch transaction_cursor 
    bulk collect into v_transactions
    limit 3;

    -- Afisam valorile comisiei
    for i in v_transactions.first .. v_transactions.last
    loop
        dbms_output.put_line(v_transactions(i).comission);
    end loop;

    -- Incrementam comisia cu 100 la fiecare tranzactie
    forall i in v_transactions.first .. v_transactions.last
    update Transaction_Table t 
        set t.comission = t.comission + 100 
        where t.id = v_transactions(i).id;

    commit;

    close transaction_cursor;
end;
```

## De creat o ierarhie de tipuri

Nu ar fi util să utilizez ierarhia de tipuri în baza de date din condiția, deci voi exemplifica printr-un exemplu.

Zicem, avem clasa de bază abstractă `Animal`, care va conține metoda `hunt()` care va returna iarași un `Animal`. Vom defini 2 subclase: `Fish` care nu prinde nimic la vânătoare și `Bear` care va prinde câte un pește. Vom avea și un tabel de animale.

Ca să permitem unui tip să fie moștenit, trebuie să aplicăm modificatorul not final la declarare. Avem o funcție finală care va permite să ștergem un animal dat din tabela de animale. Avem o funcție not final, `hunt()`, menționată mai sus:
```sql
create type Animal_Type as object
(
    id  number,
    age number,
    not final member function hunt return Animal_Type,
    /* The table is shared between the subtypes */
    final member procedure remove_self_from_table
) not final;
```

Creăm tabela polimorfică pentru animale:
```sql
create table Animal_Table of Animal_Type (id primary key);
```

Și descriem funcțiile în corp:
```sql
create type body Animal_Type as
    not final member function hunt return Animal_Type
        is 
        begin 
            raise_application_error(-20000, 'Must override hunt()');
        end;

    final member procedure remove_self_from_table
        is
        begin
            delete from Animal_Table animal
                where animal.id = self.id;
        end;
end;
```

Declarăm și definim tipul peștelui:
```sql
create type Fish_Type under Animal_Type
(
    overriding member function hunt return Animal_Type
);
/
create type body Fish_Type as
    overriding member function hunt 
        return Animal_Type
        is
        begin
            return null;      
        end;
end;
/
```

Și tipul ursului. Folosim `is of type` pentru a selecta numai peștele:
```sql
create type Bear_Type under Animal_Type
(
    overriding member function hunt return Animal_Type
);
/
create type body Bear_Type as
    overriding member function hunt 
        return Animal_Type
        is
            v_fish Fish_Type;
        begin
            select treat(value(animal) as Fish_Type)
                into v_fish
                from Animal_Table animal
                where value(animal) is of type (Fish_Type) 
                /* take the first match */
                fetch first 1 rows only;

            if (v_fish is null) then
                dbms_output.put_line('v_fish is null');
            end if;
            
            return v_fish;
        end;
end;
/
```

Iată niște inserări într-un bloc anonim:
```sql
begin
    insert into Animal_Table values(Bear_Type(1, 20));
    insert into Animal_Table values(Fish_Type(2, 1 ));
    insert into Animal_Table values(Fish_Type(3, 2 ));
    insert into Animal_Table values(Fish_Type(4, 1 ));
    insert into Animal_Table values(Bear_Type(5, 15));
    insert into Animal_Table values(Fish_Type(6, 1 ));
    insert into Animal_Table values(Fish_Type(7, 5 ));
end;
```

Verificăm codul și demonstrăm cum funcționează, într-un bloc anonim. Folosim `treat(as)` pentru a face un cast:
```sql
declare
    v_bear Bear_Type;
    v_fish Fish_Type;
    v_nothing Animal_Type;
begin
    select treat(value(animal) as Bear_Type)
        into v_bear
        from Animal_Table animal
        where animal.id = 1;

    /* The bear gets a fish from the table */
    v_fish := treat(v_bear.hunt() as Fish_Type);
    dbms_output.put_line(v_fish.id||' '||v_fish.age);

    /* The fish gets nothing when hunting */
    v_nothing := v_fish.hunt();
    if (v_nothing is not null) then
        dbms_output.put_line('It is not null!!');
    end if;

    /* Remove both the fish and the bear */
    v_fish.remove_self_from_table();
    v_bear.remove_self_from_table();

    commit;
end;
```

Putem verifica dacă înregistrările de fapt s-au șters din tabela, folosind următoarea interogare:
```sql
select value(animal).id from Animal_Table animal;
```

Nu vedem primele două înregistrări, înseamnă că codul a lucrat corect.

## Overloading

Rămâne numai să exemplific `overloading`.

Deci vom adăuga două funcții, care fiecare ia ca parametru `Animal_Type` sau `Bear_Type` și afișează numele clasei. Le vom apela într-un bloc anonim.
```sql
declare
    v_animal Animal_Type := null; 
    v_fish   Fish_Type   := null;
    v_bear   Bear_Type   := null;

    procedure test_proc(arg Animal_Type)
        is begin
            dbms_output.put_line('Animal');
        end; 
    
    procedure test_proc(arg Bear_Type)
        is begin
            dbms_output.put_line('Bear');
        end; 
begin
    test_proc(v_animal);
    test_proc(v_fish);
    test_proc(v_bear);
end;
```

Pentru prima apelare, funcția selectată este cea pentru animal. 

Pentru a doua apelare tot ea, deoarece nu am definit o funcție pentru pește, însă pește este un subtip al animalului, deci acea primă funcție poate fi apelată cu pește ca argument.

Pentru a treia apelare, este apelată funcția pentru urs, fiindcă funcțiile potrivite cu argumentele de tipuri mai specifice au prioritate mai mare decât celelalte.

Putem verifica validitatea argumentului, dacă pornim codul:
```
Animal
Animal
Bear
```

Acest concept tot nu e nimic nou și lucrează în Oracle cum am intui.

## Concluzii

Astfel am exemplificat toate concepturile și mi-am demonstrat cunoștințele.