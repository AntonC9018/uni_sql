drop type Person_Type force;
/
drop type Telephone_Varray force;
/
drop table Person_Mixed_Table force;
/

create type Person_Type as object(
    first_name  varchar2(32),
    last_name  varchar2(32)
);
/

create type Telephone_Varray as varray(5) of varchar2(32);
/
create table Person_Mixed_Table (
    person Person_Type, 
    address Address_Type,
    telephones Telephone_Varray
);

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


/* QUERIES. RUN SEPARATELY */

declare
    ion_telephones Telephone_Varray;
begin
    select t.telephones
        into ion_telephones
        from Person_Mixed_Table t
        where t.person.first_name = 'Ion';
    
    for i in ion_telephones.first .. ion_telephones.last
    loop
        dbms_output.put_line(ion_telephones(i));
    end loop;
end;


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