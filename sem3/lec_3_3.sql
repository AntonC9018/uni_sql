CREATE TABLE Clienti (
    cod integer not null primary key,
    nume varchar2(25) null,
    prenume varchar2(25) null,
    patronimic varchar2(25) null,
    adresa varchar2(36) null,
    oras varchar2(25) null,
    sex char(1) null,
    data_de_nastere date null,
    telefon varchar2(14) null
);

CREATE OR REPLACE PROCEDURE INSERT_CLIENT(
    v_cod IN Clienti.cod%TYPE,
    v_nume IN Clienti.nume%TYPE,
    v_prenume IN Clienti.prenume%TYPE,
    v_patronimic IN Clienti.patronimic%TYPE,
    v_adresa IN Clienti.adresa%TYPE,
    v_oras IN Clienti.oras%TYPE,
    v_sex IN Clienti.sex%TYPE,
    v_data_de_nastere IN Clienti.data_de_nastere%TYPE,
    v_telefon IN Clienti.telefon%TYPE,
    v_feedback IN Clienti.feedback%TYPE)
IS
BEGIN
    INSERT INTO Clienti(
        cod,
        nume,
        prenume,
        patronimic,
        adresa,
        oras,
        sex,
        data_de_nastere,
        telefon
    ) VALUES (
        v_cod,
        v_nume,
        v_prenume,
        v_patronimic,
        v_adresa,
        v_oras,
        v_sex,
        v_data_de_nastere,
        v_telefon
    );
END INSERT_CLIENT;
/

BEGIN
    /* 2. Se introduc datele */
INSERT_CLIENT(1, 'Vasilie', 'Ion', 'Ion', 'str.Stefan', 'Chisinau', 'm', TO_DATE('10.10.2000', 'dd.mm.yyyy'), 123);
INSERT_CLIENT(2, 'Ion', 'Ion', 'Ion', 'str.Gheorghe', 'Chisinau', 'm', TO_DATE('10.11.2000', 'dd.mm.yyyy'), 1235);
INSERT_CLIENT(3, 'Nastea', 'Viorel', 'Ion', 'str.Stefan', 'Chisinau', 'f', TO_DATE('10.12.2000', 'dd.mm.yyyy'), 1234);
INSERT_CLIENT(4, 'Viorica', 'Ion', 'Stefan', 'str.Viorel', 'Balti', 'f', TO_DATE('10.10.2000', 'dd.mm.yyyy'), 123);
INSERT_CLIENT(5, 'Ion', 'Ion', 'Ion', 'str.Centrala', 'Cahul', 'f', TO_DATE('10.10.1999', 'dd.mm.yyyy'), 12367);
INSERT_CLIENT(6, 'Gheorghe', 'Rosu', 'Vasile', 'str.Popusoi', 'Balti', 'm', TO_DATE('10.10.2000', 'dd.mm.yyyy'), 123);
INSERT_CLIENT(7, 'Magdalena', 'Popusoi', 'Ion', 'str.Popusoi', 'Balti', 'm', TO_DATE('10.10.1988', 'dd.mm.yyyy'), 12390);
INSERT_CLIENT(8, 'Vasilie', 'Ion', 'Ion', 'str.Stefan', 'Chisinau', 'm', TO_DATE('10.10.2000', 'dd.mm.yyyy'), 12389);
INSERT_CLIENT(9, 'Viorel', 'Popusoi', 'Ion', 'str.Vadului-Voda', 'Chisinau', 'm', TO_DATE('10.10.1990', 'dd.mm.yyyy'), 123236);
INSERT_CLIENT(10, 'Vasilie', 'Ion', 'Ion', 'str.Stefan', 'Chisinau', 'm', TO_DATE('10.10.2000', 'dd.mm.yyyy'), 123235);
END;