create or replace type tip_apartament2 as object 
(
    tip_apart varchar2(32),
    pret      number(10),
    member function valoarea_tipului return number,
    order member function order_func(other tip_apartament2) return number
);
/

create or replace type body tip_apartament2 as
    member function valoarea_tipului return number
    is begin
        if (tip_apart = 'vila') then
            return 4;
        elsif (tip_apart = 'casa') then
            return 3;
        elsif (tip_apart = 'apartament') then
            return 2;
        elsif (tip_apart = 'camin') then
            return 1;
        else
            return 0;
        end if;
    end;

    order member function order_func(other tip_apartament2)
    return number
    is begin
        if (pret = other.pret) then
            return sign(valoarea_tipului() - other.valoarea_tipului());
        else
            return sign(pret - other.pret);
        end if;
    end;
end;
/

declare
    vila_5     tip_apartament2 := tip_apartament2('vila', 5);
    camin_5    tip_apartament2 := tip_apartament2('camin', 5);
    apart_10   tip_apartament2 := tip_apartament2('apart', 10);
    apart_10_2 tip_apartament2 := tip_apartament2('apart', 10);
begin
    dbms_output.put_line('Expecting 1: ' || vila_5.order_func(camin_5));    
    dbms_output.put_line('Expecting 1: ' || apart_10.order_func(vila_5));    
    dbms_output.put_line('Expecting 1: ' || apart_10.order_func(camin_5));    
    dbms_output.put_line('Expecting -1: ' || camin_5.order_func(vila_5));    
    dbms_output.put_line('Expecting 0: ' || apart_10.order_func(apart_10_2));    
end;