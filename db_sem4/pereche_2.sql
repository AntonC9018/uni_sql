drop table Apartament;
/
drop table Proprietar;
/
drop table Address;
/

drop type tip_apartament;
/
drop type tip_proprietar;
/
drop type tip_adresa2;
/

create type tip_adresa2 as object (
    strada 	varchar2(20),
    numar 	varchar2(5),
    oras 	varchar2(20),
    tara 	varchar2(20),
    MEMBER PROCEDURE afisare
);
/

create type body tip_adresa2 as
    member PROCEDURE afisare
    is 
    begin
        dbms_output.put_line(
               'strada: '        || strada
            || ', numar casei: ' || numar
            || ', orasul: '      || oras
            || ', tara: '        || tara);
    end;
end;
/

create type tip_proprietar as object (
    nume 	varchar2(20),
    prenume varchar2(20),
    data_de_nastere date,
    MEMBER FUNCTION varsta return number
);
/

create type body tip_proprietar as
    member function varsta
    return number
    is
    begin
        return months_between(sysdate, data_de_nastere) / 12;
    end;
end;
/

create type tip_apartament as object
(
    adresa      tip_adresa2,
    proprietar  tip_proprietar,
    tip_apart   varchar2(32),
    etaj        number(2),
    pret        number(10)
);
/

create table Proprietar of tip_proprietar;
/

create table Address of tip_adresa2;
/

create table Apartament of tip_apartament;
/

insert into Apartament values(
    tip_apartament(
        tip_adresa2('str.Stefan', '123', 'Stefan', 'RM'),
        tip_proprietar('Vasea', 'Ion', TO_DATE('10.10.2000', 'dd.mm.yyyy')),
        'villa', 0, 10000
    )
);
/

insert into Proprietar values(
    tip_proprietar('Vasea', 'Ion', TO_DATE('10.10.2000', 'dd.mm.yyyy'))
);
/

select * from Apartament;

select * from Apartament where strada = 'str.Stefan';

select * from Apartament where proprietar = (select * from Proprietar where rownum = 1);

select count(*) from Apartament group by tip_apartament;


declare
    propr tip_proprietar;
    apart tip_apartament;
begin 
    select value(ap)
        into apart
        from Apartament ap
        where ap.adresa.strada = 'str.Stefan';

    apart.adresa.afisare();

    select value(pr)
        into propr
        from Proprietar pr
        where pr.nume = 'Vasea';

    dbms_output.put_line(propr.nume);
end;
