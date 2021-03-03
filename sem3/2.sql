DROP TABLE Florarie;
/
CREATE TABLE Florarie (
    cod integer not null primary key,
    are_office char(1),
    nr_angajati integer,
    nr_tipuri_flori integer,
    regiunea varchar2(64) null,
    oras varchar2(64) null,
    adresa varchar2(64) null,
    pret_mediu number(8,2) null
);
/

CREATE OR REPLACE PROCEDURE INSERT_FLORARIE(
    v_cod IN Florarie.cod%TYPE,
    v_are_office IN Florarie.are_office%TYPE,
    v_nr_angajati IN Florarie.nr_angajati%TYPE,
    v_nr_tipuri_flori IN Florarie.nr_tipuri_flori%TYPE,
    v_regiunea IN Florarie.regiunea%TYPE,
    v_oras IN Florarie.oras%TYPE,
    v_adresa IN Florarie.adresa%TYPE,
    v_pret_mediu IN Florarie.pret_mediu%TYPE)
IS
BEGIN
    INSERT INTO Florarie(
        cod,
        are_office,
        nr_angajati,
        nr_tipuri_flori,
        regiunea,
        oras,
        adresa,
        pret_mediu
    ) VALUES (
        v_cod,
        v_are_office,
        v_nr_angajati,
        v_nr_tipuri_flori,
        v_regiunea,
        v_oras,
        v_adresa,
        v_pret_mediu
    );
END INSERT_FLORARIE;
/

BEGIN
    /* 2. Se introduc datele */
    INSERT_FLORARIE(1, 'n', 5, 56, 'Chisinau', 'Chisinau', 'str.Stefan', 10.2);
    INSERT_FLORARIE(2, 'd', 1, 6, 'Chisinau', 'Chisinau', 'str.Ion', 11.2);
    INSERT_FLORARIE(3, 'd', 1, 15, 'Balti', 'Balti', 'str.Bogdan', 10.5);
    INSERT_FLORARIE(4, 'n', 1, 15, 'Chisinau', 'Chisinau', 'str.Stefan', 20.0);
    INSERT_FLORARIE(5, 'd', 2, 125, 'Balti', 'Balti', 'str.Bogdan', 17.3);
    INSERT_FLORARIE(6, 'n', 3, 15, 'Chisinau', 'Chisinau', 'str.Stefan', 90.0);
    INSERT_FLORARIE(7, 'n', 1, 15, 'Chisinau', 'Chisinau', 'str.Bogdan', 10.2);
    INSERT_FLORARIE(8, 'd', 2, 52, 'Chisinau', 'Chisinau', 'str.Creanga', 10.5);
    INSERT_FLORARIE(9, 'd', 8, 52, 'Balti', 'Balti', 'str.Ion', 11.2);
    INSERT_FLORARIE(10, 'n', 1, 10, 'Chisinau', 'Chisinau', 'str.Bogdan', 10.2);
END;
/