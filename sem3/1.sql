DROP TABLE Apartament;
/
/* 1. Se creaza tabela */
CREATE TABLE Apartament (
    cod integer not null primary key,
    tipul_apart varchar2(10) null,
    suprafata number(6,2) null,
    etaj integer null,
    separat char(1),
    balcon char(1),
    nr_de_balc integer null,
    nr_de_cam integer null,
    regiunea varchar2(25) null,
    adresa varchar2(34) null,
    pretul number(8,2) null
);
/

CREATE OR REPLACE PROCEDURE INSERT_APARTMENT(
    v_cod IN Apartament.cod%TYPE,
    v_tipul_apart IN Apartament.tipul_apart%TYPE,
    v_suprafata IN Apartament.suprafata%TYPE,
    v_etaj IN Apartament.etaj%TYPE,
    v_separat IN Apartament.separat%TYPE,
    v_balcon IN Apartament.balcon%TYPE,
    v_nr_de_balc IN Apartament.nr_de_balc%TYPE,
    v_nr_de_cam IN Apartament.nr_de_cam%TYPE,
    v_regiunea IN Apartament.regiunea%TYPE,
    v_adresa IN Apartament.adresa%TYPE,
    v_pretul IN Apartament.pretul%TYPE) 
IS
BEGIN
    INSERT INTO Apartament(
        cod,
        tipul_apart,
        suprafata,
        etaj,
        separat,
        balcon,
        nr_de_balc,
        nr_de_cam,
        regiunea,
        adresa,
        pretul
    ) VALUES (
        v_cod,
        v_tipul_apart,
        v_suprafata,
        v_etaj,
        v_separat,
        v_balcon,
        v_nr_de_balc,
        v_nr_de_cam,
        v_regiunea,
        v_adresa,
        v_pretul
    );
END INSERT_APARTMENT;
/

BEGIN
    /* 2. Se introduc datele */
    INSERT_APARTMENT(1, 'tip1', 50.2, 5, 'd', 'd', 1, 4, 'Botanica', 'str.Stefan', 20000);
    INSERT_APARTMENT(2, 'tip1', 60.2, 1, 'd', 'n', 2, 3, 'Centru', 'str.Ion', 30000);
    INSERT_APARTMENT(3, 'tip0', 70.2, 2, 'd', 'd', 3, 4, 'Centru', 'str.Stefan', 40000);
    INSERT_APARTMENT(4, 'tip2', 20.2, 4, 'd', 'd', 4, 3, 'Botanica', 'str.Creanga', 520000);
    INSERT_APARTMENT(5, 'tip1', 30.2, 4, 'd', 'd', 5, 4, 'Botanica', 'str.Ion', 10000);
    INSERT_APARTMENT(6, 'tip1', 60.5, 3, 'd', 'd', 6, 4, 'Centru', 'str.Stefan', 10000);
    INSERT_APARTMENT(7, 'tip1', 80.21, 2, 'd', 'd', 2, 3, 'Botanica', 'str.Stefan', 20000);
    INSERT_APARTMENT(8, 'tip2', 19.12, 1, 'd', 'd', 2, 4, 'Botanica', 'str.Puskin', 20000);
    INSERT_APARTMENT(9, 'tip2', 90.2, 3, 'd', 'n', 1, 3, 'Botanica', 'str.Stefan', 20000);
    INSERT_APARTMENT(10, 'tip0', 5.2, 1, 'd', 'n', 1, 4, 'Botanica', 'str.Stefan', 200000);

    CREATE TABLE Cumparator (
    cod integer not null primary key,
    nume varchar2(25) null,
    prenume varchar2(25) null,
    patronimic varchar2(25) null,
    adresa varchar2(36) null,
    oras varchar2(25) default 'Balti',
    sex char(1) null,
    data_de_nastere date null,
    telefon varchar2(14) null
);

