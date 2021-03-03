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

INSERT INTO Cumparator(
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
    1,
    'Vasilie',
    'Ion',
    'Ion',
    'str.Stefan',
    'Chisinau',
    'm',
    TO_DATE('10.10.2000', 'dd.mm.yyyy'),
    123
);


INSERT INTO Cumparator(
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
    2,
    'Ion',
    'Ion',
    'Ion',
    'str.Gheorghe',
    'Chisinau',
    'm',
    TO_DATE('10.11.2000', 'dd.mm.yyyy'),
    1235
);


INSERT INTO Cumparator(
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
    3,
    'Nastea',
    'Viorel',
    'Ion',
    'str.Stefan',
    'Chisinau',
    'f',
    TO_DATE('10.12.2000', 'dd.mm.yyyy'),
    1234
);


INSERT INTO Cumparator(
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
    4,
    'Viorica',
    'Ion',
    'Stefan',
    'str.Viorel',
    'Balti',
    'f',
    TO_DATE('10.10.2000', 'dd.mm.yyyy'),
    123
);


INSERT INTO Cumparator(
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
    5,
    null,
    null,
    'Ion',
    'str.Centrala',
    'Cahul',
    'f',
    TO_DATE('10.10.1999', 'dd.mm.yyyy'),
    12367
);


INSERT INTO Cumparator(
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
    6,
    'Gheorghe',
    'Rosu',
    'Vasile',
    'str.Popusoi',
    'Balti',
    'm',
    TO_DATE('10.10.2000', 'dd.mm.yyyy'),
    123
);


INSERT INTO Cumparator(
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
    7,
    'Magdalena',
    'Popusoi',
    'Ion',
    'str.Popusoi',
    'Balti',
    'm',
    TO_DATE('10.10.1988', 'dd.mm.yyyy'),
    12390
);


INSERT INTO Cumparator(
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
    8,
    'Vasilie',
    'Ion',
    'Ion',
    'str.Stefan',
    'Chisinau',
    'm',
    TO_DATE('10.10.2000', 'dd.mm.yyyy'),
    12389
);


INSERT INTO Cumparator(
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
    9,
    'Viorel',
    'Popusoi',
    'Ion',
    'str.Vadului-Voda',
    'Chisinau',
    'm',
    TO_DATE('10.10.1990', 'dd.mm.yyyy'),
    123236
);


INSERT INTO Cumparator(
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
    10,
    'Vasilie',
    'Ion',
    'Ion',
    'str.Stefan',
    'Chisinau',
    'm',
    TO_DATE('10.10.2000', 'dd.mm.yyyy'),
    123235
);