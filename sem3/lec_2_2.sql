CREATE TABLE Cumparator_1 (
    cod integer not null primary key,
    nume varchar2(25) null,
    prenume varchar2(25) null,
    patronimic varchar2(25) null,
    adresa varchar2(36) null,
    oras varchar2(25) default 'Balti',
    sex char(1) null,
    data_de_nastere date null,
    telefon varchar2(14) null,
    CONSTRAINT check_nume
    CHECK (nume = upper(nume))
);