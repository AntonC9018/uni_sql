create type tip_adresa as object (
    strada 	varchar2(20),
    numar 	varchar2(5),
    oras 	varchar2(20),
    tara 	varchar2(20)
);


create or replace type tip_angajat as object (
    cod_personal number(9),
    nume varchar2(20),
    prenume varchar2(20),
    salariu number(8),
    adresa tip_adresa,
    MEMBER FUNCTION categorie_salariu (limita1 IN number, limita2 IN number) RETURN number,
    PRAGMA RESTRICT_REFERENCES (categorie_salariu, WNDS, WNPS, RNPS)
);
/
CREATE OR REPLACE TYPE BODY tip_angajat AS 
    MEMBER FUNCTION categorie_salariu(Limita1 IN number, limita2 IN number) 
    RETURN number 
    IS Categorie number(1);	
    Begin
        IF salariu < limita1 THEN categorie :=1;
        ELSIF salariu < limita2 THEN categorie :=2;
        ELSE categorie :=3;
        END IF;
        RETURN categorie;
    End categorie_salariu;
End;
/

create table profesor(
    angajat tip_angajat,
    titlu varchar2(10),
    functie varchar2(20),
    constraint pk_cod primary key(angajat.cod_personal)
);
/

insert into profesor(angajat,titlu,functie)
values(
    tip_angajat(111, 'Bodrug', 'Svetlana', 1000, tip_adresa('Mateevici', '31', 'Chisinau', 'RM')),
    'doctor', 'profesor'
);
/


declare
    emp tip_angajat;
begin 
    emp := tip_angajat(111, 'Bodrug', 'Svetlana', 1000, 
        tip_adresa('Mateevici', '31', 'Chisinau', 'RM')
    );
    dbms_output.put_line(
           'nume: '     || emp.nume 
        || ', prenume: ' || emp.prenume 
        || ', strada: '       || emp.adresa.strada
        || ', numar casei: '  || emp.adresa.numar
        || ', orasul: '       || emp.adresa.oras
        || ', tara: '         || emp.adresa.tara
        || ', salariu: '             || emp.salariu
        || ', categorie salariu: '   || emp.categorie_salariu(1000, 2000)
        || ', cod personal: ' || emp.cod_personal
    );
end;




create or replace type tip_triunghi as object
(
    latura_1 number(5, 2),
    latura_2 number(5, 2),
    latura_3 number(5, 2),
    member function exista return boolean,
    PRAGMA RESTRICT_REFERENCES (exista, WNDS, WNPS, RNPS)
);
/

create or replace type body tip_triunghi as
    member function exista
    return boolean
    is 
    begin
        return latura_1 < latura_2 + latura_3 
            and latura_2 < latura_1 + latura_3
            and latura_3 < latura_1 + latura_2;
    end;
end;
/

declare 
    t tip_triunghi;
begin
    t := tip_triunghi(1, 2, 2);
    if t.exista() then
        dbms_output.put_line('Exista.');
    else
        dbms_output.put_line('Nu Exista.');
    end if;

    t := tip_triunghi(1, 2, 4);
    if t.exista() then
        dbms_output.put_line('Exista.');
    else
        dbms_output.put_line('Nu Exista.');
    end if;
end;








