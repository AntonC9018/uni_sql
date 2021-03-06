drop type Animal_Type force;
/
drop type Fish_Type force;
/
drop type Bear_Type force;
/
drop table Animal_Table force;


create type Animal_Type as object
(
    id  number,
    age number,
    not final member function hunt return Animal_Type,
    /* The table is shared between the subtypes */
    final member procedure remove_self_from_table
) not final;
/

create table Animal_Table of Animal_Type (id primary key);
/

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
/

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

begin
    insert into Animal_Table values(Bear_Type(1, 20));
    insert into Animal_Table values(Fish_Type(2, 1 ));
    insert into Animal_Table values(Fish_Type(3, 2 ));
    insert into Animal_Table values(Fish_Type(4, 1 ));
    insert into Animal_Table values(Bear_Type(5, 15));
    insert into Animal_Table values(Fish_Type(6, 1 ));
    insert into Animal_Table values(Fish_Type(7, 5 ));
end;
/

/* QUERIES */


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

/

select value(animal).id from Animal_Table animal;