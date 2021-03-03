# Darea de seama la Baze de Date, Apex

*Student*: **Curmanschii Anton**

*Grupa*: **IA1901**.

## Lectia 1

Am setat Cabinetul pe Apex Oracle.

## Lectia 2

Definim si introducem inregistrarile in tabelul **Apartament**.

```sql
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
END;
/
```

Definim si introducem inregistrarile in primul tabel peronal **Florarie**.

```sql
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
```

## Lectia 3

1. Selectaţi toate înregistrările din tabelul **apartament**, care au `nr_de_cam=3`.

```sql
select * from Apartament where nr_de_cam = 3
```

2. Selectaţi câmpurile : cod, tipul_apart, regiunea, nr_de_cam, suprafata, etaj,balcon din tabelul "apartament" a înregistrărilor, care se află în regiunea "Botanica".

```sql
select cod, tipul_apart, regiunea, nr_de_cam, suprafata, etaj, balcon from Apartament where regiunea = 'Botanica'
```

3. Afişaţi toate apartamentele care au preţul<=200000.

```sql
select * from Apartament where pretul <= 200000
```

4. Creaţi tabelul "cumparator" ce conţine următoarele câmpuri:

Nr. |Numele câmpului |tipul  |
|-|-|-| 
1| cod| integer not null primary key |
2| nume| varchar2(25) null |
3| prenume| varchar2(25) null |
4| patronimicul| varchar2(25) null |
5|  adresa | varchar2(36) null |
6| orasul|varchar2(25) default ‘Balti’ |
7|  sexul|char(1) null |
8| data_nast|date null |
9| telefon| varchar2(14) null |

```sql
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
```
5. Introduceţi 10 înregistrări în tabelul "cumparator".

```sql
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
```

6. Afişaţi toţi cumparatorii din orasul "Chisinau".

```sql
select * from Cumparator where oras = 'Chisinau'
```

7. Afişaţi primele 3 înregistrări din tabelul "apartament".

```sql
select * from Apartament where cod <= 3
```

8. Afişaţi toţi cumparatorii nascuti la data de "10.09.1987".

```sql
select * from Cumparator where data_de_nastere = TO_DATE('10.09.1987', 'dd.mm.yyyy')
```

9. Creaţi  tabelul "cumparatorule" cu aceleaşi câmpuri ca si tabelul "comparator", unde vom folosi  constrângerea **check** ca numele cumpărătorului să fie înregistrat doar cu majuscule(litere mari).

```sql
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
```

10. Introduceţi o înregistrare în tabelul "cumparatorule".

```sql
INSERT INTO Cumparator_1(
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
    'VASILIE',
    'Ion',
    'Ion',
    'str.Stefan',
    'Chisinau',
    'm',
    TO_DATE('10.10.2000', 'dd.mm.yyyy'),
    123
);
```

11. Creati al 2-lea tabel la tema personala si introduceti 10 inregistrari.

```sql
CREATE TABLE Tranzactii (
    cod integer not null primary key,
    florarie_cod integer not null,
    /* pe urma voi adauga si client_cod */
    locatie varchar2(25) null,
    pret integer not null,
    numar_flori integer not null,
    feedback integer null,

    CONSTRAINT check_feedback
    CHECK (feedback <= 5 and feedback >= 1),

    CONSTRAINT fk_florarie_cod
    FOREIGN KEY (florarie_cod)
    REFERENCES Florarie(cod)
);
/

CREATE OR REPLACE PROCEDURE INSERT_TRANZACTIE(
    v_cod IN Tranzactii.cod%TYPE,
    v_florarie_cod IN Tranzactii.florarie_cod%TYPE,
    v_locatie IN Tranzactii.locatie%TYPE,
    v_pret IN Tranzactii.pret%TYPE,
    v_numar_flori IN Tranzactii.numar_flori%TYPE,
    v_feedback IN Tranzactii.feedback%TYPE)
IS
BEGIN
    INSERT INTO Tranzactii(
        cod,
        florarie_cod,
        locatie,
        pret,
        numar_flori,
        feedback
    ) VALUES (
        v_cod,
        v_florarie_cod,
        v_locatie,
        v_pret,
        v_numar_flori,
        v_feedback 
    );
END INSERT_TRANZACTIE;
/

BEGIN
    /* 2. Se introduc datele */
    INSERT_TRANZACTIE(1, 1, 'str.Stefan', 100, 10, 5);
    INSERT_TRANZACTIE(2, 2, 'str.Cioban', 20, 1, 3);
    INSERT_TRANZACTIE(3, 2, 'str.Stefan', 300, 20, 4);
    INSERT_TRANZACTIE(4, 2, 'str.Grigore', 500, 20, 4);
    INSERT_TRANZACTIE(5, 1, 'str.Stefan', 200, 10, 1);
    INSERT_TRANZACTIE(6, 3, 'str.Viteazul', 140, 5, 1);
    INSERT_TRANZACTIE(7, 6, 'str.Stefan', 40, 2, 3);
    INSERT_TRANZACTIE(8, 6, 'str.Stefan', 400, 20, 2);
    INSERT_TRANZACTIE(9, 5, 'str.Mihai', 10, 11, 4);
    INSERT_TRANZACTIE(10, 2, 'str.Stefan', 110, 3, 5);
END;
```

## Lectia 4

1. Creaza tabelul Makler.

```sql
CREATE TABLE Makler (
    cod integer not null primary key,
    cod_cump integer not null,
    cod_apart integer not null,
    data_solicit date null,
    data_livr date null,
    comentarii varchar(40) null
);
/

CREATE OR REPLACE PROCEDURE INSERT_MAKLER(
    v_cod IN Makler.cod%TYPE,
    v_cod_cump IN Makler.cod_cump%TYPE,
    v_cod_apart IN Makler.cod_apart%TYPE,
    v_data_solicit IN Makler.data_solicit%TYPE,
    v_data_livr IN Makler.data_livr%TYPE,
    v_comentarii IN Makler.comentarii%TYPE)
IS
BEGIN
    INSERT INTO Makler(
        cod,
        cod_cump,
        cod_apart,
        data_solicit,
        data_livr,
        comentarii
    ) VALUES (
        v_cod,
        v_cod_cump,
        v_cod_apart,
        v_data_solicit,
        v_data_livr,
        v_comentarii 
    );
END INSERT_MAKLER;
/

BEGIN
    /* 2. Se introduc datele */
    INSERT_MAKLER(1, 1, 1, TO_DATE('10.10.2000', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(2, 1, 2, TO_DATE('10.10.2001', 'dd.mm.yyyy'), TO_DATE('12.10.2001', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(3, 3, 2, TO_DATE('11.10.2002', 'dd.mm.yyyy'), TO_DATE('10.01.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(4, 4, 2, TO_DATE('10.10.2003', 'dd.mm.yyyy'), TO_DATE('10.10.2001', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(5, 5, 1, TO_DATE('10.10.2004', 'dd.mm.yyyy'), TO_DATE('11.01.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(6, 6, 3, TO_DATE('11.10.2005', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(7, 7, 6, TO_DATE('10.10.2006', 'dd.mm.yyyy'), TO_DATE('21.10.2001', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(8, 2, 6, TO_DATE('10.10.2007', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(9, 8, 10, TO_DATE('10.10.2008', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER(10, 9, 2, TO_DATE('10.10.2009', 'dd.mm.yyyy'), TO_DATE('10.10.2001', 'dd.mm.yyyy'), 'Super');
END;
```

2. Creaza tabelul Makler_1.

```sql
CREATE TABLE Makler_1 (
    cod integer not null primary key,
    cod_cump integer not null,
    cod_apart integer not null,
    data_solicit date null,
    data_livr date null,
    comentarii varchar(40) null
);
/

CREATE OR REPLACE PROCEDURE INSERT_MAKLER_1(
    v_cod IN Makler_1.cod%TYPE,
    v_cod_cump IN Makler_1.cod_cump%TYPE,
    v_cod_apart IN Makler_1.cod_apart%TYPE,
    v_data_solicit IN Makler_1.data_solicit%TYPE,
    v_data_livr IN Makler_1.data_livr%TYPE,
    v_comentarii IN Makler_1.comentarii%TYPE)
IS
BEGIN
    INSERT INTO Makler_1(
        cod,
        cod_cump,
        cod_apart,
        data_solicit,
        data_livr,
        comentarii
    ) VALUES (
        v_cod,
        v_cod_cump,
        v_cod_apart,
        v_data_solicit,
        v_data_livr,
        v_comentarii 
    );
END INSERT_MAKLER_1;
/

BEGIN
    /* 2. Se introduc datele */
    INSERT_MAKLER_1(1, 1, 1, TO_DATE('10.10.2000', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(2, 1, 2, TO_DATE('10.10.2001', 'dd.mm.yyyy'), TO_DATE('12.10.2001', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(3, 3, 2, TO_DATE('11.10.2002', 'dd.mm.yyyy'), TO_DATE('10.01.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(4, 4, 2, TO_DATE('10.10.2003', 'dd.mm.yyyy'), TO_DATE('10.10.2001', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(5, 5, 1, TO_DATE('10.10.2004', 'dd.mm.yyyy'), TO_DATE('11.01.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(6, 6, 3, TO_DATE('11.10.2005', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(7, 7, 6, TO_DATE('10.10.2006', 'dd.mm.yyyy'), TO_DATE('21.10.2001', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(8, 2, 6, TO_DATE('10.10.2007', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(9, 8, 10, TO_DATE('10.10.2008', 'dd.mm.yyyy'), TO_DATE('10.10.2000', 'dd.mm.yyyy'), 'Super');
    INSERT_MAKLER_1(10, 9, 2, TO_DATE('10.10.2009', 'dd.mm.yyyy'), TO_DATE('10.10.2001', 'dd.mm.yyyy'), 'Super');
END;
```

3. Din tabelul "makler1" ştergeţi înregistrările cu data_livr=’02.02.2020’.

```sql
delete from Makler_1 where data_livr='02.02.2000'
```

4. Din tabelul "makler1" ştergeţi primele 3 înregistrări.  

```sql
delete from Makler_1 where cod <= 3
```

5. Eliminaţi tabelul "makler1".

```sql
delete Makler_1
```

6. Selectaţi înregistrările distincte ale câmpului "regiunea" din tabelul "apartament".

```sql
select distinct regiunea from Apartament
```

7. Afişaţi toţi cumpărătorii din oraşul "Chisinau" de sexul masculin cu numele "Voda" sau "Burca".

```sql
select * from Cumparator where sex = 'm' and (nume = 'Voda' or nume = 'Burca') and oras = 'Chisinau'
```

8. Afişaţi toate apartamentele din regiunea "botanica" sau "centru" şi nr_de_cam=3.

```sql
select * from Apartament where (regiunea = 'Botanica' or regiunea = 'Centru') and nr_de_cam = 3
```

9. Afişaţi toate apartamentele, care nu sunt din regiunea "centru".

```sql
select * from Apartament where regiunea != 'Centru'
```

10. Afişaţi toate apartamentele din regiunea "centru" cu nr_de_cam=3 sau 4.

```sql
select * from Apartament where regiunea = 'Centru' and (nr_de_cam = 3 or nr_de_cam = 4)
```

11. Creaţi tabelul trei de la tema personală. 

```sql
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
```

### Alcătuiţi 6 interogări folosind operatorii logici şi sintaxa distinct ( la tema personală). 

1. Se adauga keia foreign.

```sql
ALTER TABLE Tranzactii ADD client_cod integer default 1;
```

2. Se adauga keia foreign (2).

```sql
ALTER TABLE Tranzactii ADD CONSTRAINT fk_client_cod FOREIGN KEY (client_cod) REFERENCES Clienti(cod);
```

3. Schimbam client_cod sa fie egal cu cod.

```sql
UPDATE Tranzactii SET client_cod = cod
```

4. Numele distinct.

```sql
SELECT DISTINCT nume FROM Clienti
```

5. Prenumele distinct.

```sql
SELECT DISTINCT prenume FROM Clienti where nume = 'Ion'
```

6. Orasul distinct.

```sql
SELECT DISTINCT oras FROM Clienti where nume = 'Ion'
```

7. nume=Ion prenume=Ion sau nume=Magdalena.

```sql
SELECT * FROM Clienti where nume = 'Ion' and prenume = 'Ion' or nume = 'Magdalena'
```

8. Prenumele si numele nu sunt ambii Ion.

```sql
SELECT * FROM Clienti where not (nume = 'Ion' and prenume = 'Ion')
```

## Lectia 5

1. Adăugaţi câmpul "tara" în tabelul "apartament" (cu valoarea prestabilită "Moldova").

```sql
alter table Apartament add tara varchar2(32) default 'Moldova'
```

2. Transformaţi tipul atributului "tara" din char(25) în varchar2(25).

```sql
alter table Apartament modify tara varchar2(32)
```

3. Modificaţi valorile implicite ale câmpului "tara" din "Moldova" în "Ungaria".

```sql
alter table Apartament modify tara default 'Ungaria'
```

4. Introduceţi 3 înregistrări  în tabelul "apartament".

```sql
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
    pretul,
    tara
) VALUES (11, 'tip1', 50.2, 5, 'd', 'd', 1, 4, 'Botanica', 'str.Stefan', 20000, 'Romania');

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
    pretul,
    tara
) VALUES (12, 'tip2', 52.2, 52, 'd', 'd', 1, 4, 'Botanica', 'str.Stefan', 200002, 'Moldova');

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
) VALUES (13, 'tip1', 50.2, 5, 'd', 'd', 1, 4, 'Botanica', 'str.Stefan', 20000);
```
5. Afişaţi toate înregistrările  din ţara "Ungaria".

```sql
SELECT * FROM Apartament WHERE tara='Ungaria'
```

6. Eliminaţi câmpul "tara" din tabelul "apartament".

```sql
ALTER TABLE Apartament DROP COLUMN tara
```

7. Afişaţi toate apartamentele din regiunea "centru" de tipul "143".

```sql
SELECT * FROM APARTAMENT WHERE regiunea='centru' and tipul_apart='143'
```

8. Afişaţi toate apartamentele de la etajul 5 cu nr_de_cam=3.

```sql
SELECT * FROM APARTAMENT WHERE etaj=5 and nr_de_cam=3
```

9. Afişaţi toate apartamentele cu nr_de_balc=3 sau 4.     

```sql
SELECT * FROM APARTAMENT WHERE nr_de_balc=3 or nr_de_balc=4
```

10.  Afişaţi toate înregistrările  din regiunea "Telecentru" cu pretul<=300000.

```sql
SELECT * FROM APARTAMENT WHERE regiunea='Telecentru' and pretul<=300000
```

11.  Afişaţi toate apartamentele care nu sunt de la etajul 7.
```sql
SELECT * FROM APARTAMENT WHERE etaj!=7
```
12. Selectaţi  toate înregistrările  din tabelul "apartament", care se află mai jos  de etajul 6.
```sql
SELECT * FROM APARTAMENT WHERE etaj < 6
```
13. Schimbaţi denumirea câmpului "regiunea" în "regiune".
```sql
ALTER TABLE Apartament RENAME COLUMN regiunea TO regiune
```

### Alcătuiţi 7 sarcini la tema personală. (folosiţi instrucţiunea alter table) 

1. Renumim sex la sexul.

```sql
ALTER TABLE Clienti RENAME COLUMN sex TO sexul
```

2. Renumim inapoi.

```sql
ALTER TABLE Clienti RENAME COLUMN sexul TO sex
```

3. Renumim data_de_nastere.

```sql
ALTER TABLE Clienti RENAME COLUMN data_de_nastere TO data_nast
```

4. Renumim data_nast.

```sql
ALTER TABLE Clienti RENAME COLUMN data_nast TO data_de_nastere
```

5. Oras implicit = Chisinau.

```sql
ALTER TABLE Clienti MODIFY oras default 'Chisinau'
```

6. Tipul orasului = varchar(32).

```sql
ALTER TABLE Clienti MODIFY oras varchar(32)
```

7. Tipul orasului = varchar2(32).

```sql
ALTER TABLE Clienti MODIFY oras varchar2(32)
```

## Lectia 6

1. Afişaţi toate apartamentele de la etajul 5 , cu nr_de _cam=3 din regiunea  "Botanica".

```sql
select * from apartament where etaj=5 and nr_de_cam=3 and regiune='Botanica'
```

2. La  înregistrarea cu cod=1 din tabelul "apartament" modificaţi etajul 4 în 3 şi regiunea din "Telecentru" în "Botanica".

```sql
update apartament set etaj=3, regiune='Botanica' where etaj=4 and regiune='Telecentru' and cod=1
```

3. Modificaţi înregistrarea a 2-a  din nr_de_balc=4 în 3  din regiunea "Botanica" în "Rascani".

```sql
update Apartament set nr_de_balc=3, regiune='Rascani' where nr_de_balc=4 and regiune='Botanica' and cod=2
```

4. Afisaţi toate apartamentele din regiunea "Botanica" cu nr_de_cam=3 de la etajul 4.

```sql
SELECT * FROM Apartament where regiune='Botanica' and nr_de_cam=3 and etaj=4
```

5. Afisaţi toate apartamentele de la etajul 2 cu pretul <=70000 din regiunea "Telecentru".

```sql
SELECT * FROM Apartament where etaj=2 and pretul<=70000 and regiune='Telecentru'
```

6. Afisaţi toate apartamentele ignorându-le pe cele din regiunea "Botanica".

```sql
SELECT * FROM Apartament where regiune!='Botanica'
```

7. Afisaţi toţi cumpărătorii din oraşul "Chisinau" sau "Balti".

```sql
SELECT * FROM Cumparator where oras='Chisinau' or oras='Balti'
```

8. Afisaţi toţi cumpărătorii născuţi între anii 1983 şi 1990.

```sql
SELECT * FROM Cumparator where extract(year from data_de_nastere) between 1983 and 1990
```
9. Afisaţi toţi cumpărătorii născuţi în luna octombrie. 

```sql
SELECT * FROM Cumparator where extract(month from data_de_nastere)=9
```

10. Afisaţi toţi cumpărătorii născuţi în ziua a 6-a a lunii.     

```sql
SELECT * FROM Cumparator where extract(day from data_de_nastere)=6
```

11. Afisaţi toate apartamentele regiunea cărora se începe cu litera "T".  

```sql
SELECT * FROM Apartament where regiune like 'T%'
```

12. Afisaţi toate apartamentele regiunea cărora se termină cu litera "a".  

```sql
SELECT * FROM Apartament where regiune like '%a'
```

13. Afisaţi toţi cumpărătorii numele căroraconţine "da".  

```sql
SELECT * FROM Cumparator where nume like '%da%'
```

14. Afisaţi toate apartamentele cu nr_de_cam=2 sau 4 din regiunea "Telecentru" de tipul "143".    

```sql
select * from Apartament where tipul_apart='143' and nr_de_cam=2 or nr_de_cam=4 and regiune='Telecentru'
```

15. Afisaţi toţi cumpărătorii din orasul "Chisinau" numele cărora se începe cu "V" şi sunt născuţi între anii 1980 şi 1990.     

```sql
SELECT * FROM Cumparator where nume like 'V%' and extract(year from data_de_nastere) between 1980 and 1990 and oras='Chisinau'
```

16. Afisaţi toţi cumpărătorii de genul feminin,  născuţi în luna a 10-a a anului 1987 , numarul de telefon a cărora se începe cu "06".    

```sql
SELECT * FROM Cumparator where telefon like '06%' and extract(month from data_de_nastere)=10 and extract(year from data_de_nastere)=1987 and oras='Chisinau' and sex='f'
```

### Alcătuiţi 10 sarcini la tema personala.(folosiţi instrucţiunea updateşifuncţiile de extragere a anului, lunei si zilei)

1. Codul florariei este intre 2 and 5.

```sql
SELECT * FROM Florarie where cod between 2 and 5
```

2. Florarii fara office.

```sql
SELECT * FROM Florarie where are_office='n'
```

3. Regiunea se incepe cu **B**.

```sql
SELECT * FROM Florarie where regiunea like 'B%'
```

4. Strada se incepe cu **B**.

```sql
SELECT * FROM Florarie where adresa like 'str.B%'
```

5. Pretul este intre 1 si 11.

```sql
SELECT * FROM Florarie where pret_mediu between 1 and 11
```

6. Feedback este intre 4 si 5.

```sql
SELECT * FROM Florarie where feedback between 4 and 5
```

7. In tabelul Florarie se adauga campul data fondarii.

```sql
ALTER TABLE Florarie ADD data_fondarii date default '10.10.2000' not null 
```

8. Schimbam data fondarii la Florarii unde cod < 3.

```sql
UPDATE Florarie SET data_fondarii='9.9.2009' where cod<3 
```

9.  Schimbam data fondarii la Florarii unde cod=1 si data_fondarii='9.9.2009'.

```sql
UPDATE Florarie SET data_fondarii='9.10.2009' where data_fondarii='9.9.2009' and cod=1 
```

10.  Schimbam data fondarii la Florarii unde cod=2 si data_fondarii='9.9.2009'.

```sql
UPDATE Florarie SET data_fondarii='9.11.2009' where data_fondarii='9.9.2009' and cod=2 
```

11. Schimbam data fondarii la Florarii unde anul fondarii este 2000.

```sql
UPDATE Florarie SET data_fondarii='09.01.2012' where extract(year from data_fondarii)=2000
```

12. Schimbam data fondarii la Florarii unde luna fondarii este 9.

```sql
UPDATE Florarie SET data_fondarii='09.01.2012' where extract(month from data_fondarii)=9
```

13. Schimbam data fondarii la Florarii unde ziua fondarii este 1.

```sql
UPDATE Florarie SET data_fondarii='09.01.2012' where extract(day from data_fondarii)=1
```


## Lectia 7


1. Câte înregistrări distincte are câmpul “tipul_apart” din tabelul “apartament”?

```sql
select count(distinct tipul_apart) as nr_tipul from apartament
```

2. Calculaţi câte înregistrări din regiunea “Telecentru” sunt în tabelul “apartament”.

```sql
select count(regiune) as nr_Telecentru from apartament where regiune='Telecentru'
```

3. Calculaţi câţi cumpărători din oraşul “Chisinau” cu numele ce se începe cu litera “V” aveţi. 

```sql
select count(*) as nr_cump from Cumparator where oras='Chisinau' and nume like 'V%'
```

4. Calculaţi câte apartamente din regiunea “Botanica” cu nr_de_cam=3” sau 4 sunt.

```sql
select count(*) as nr_apart from Apartament where regiune='Botanica' and nr_de_cam=3 or nr_de_cam=4
```

5. Calculaţi suma tuturor apartamentelor din regiunea “Botanica” de la etajul 5. 

```sql
select count(*) as nr_apart from Apartament where regiune='Botanica' and etaj=5
```

6. Calculaţi suma tuturor  apartamentelor  de tipul “143” din regiunea “Botanica”. 

```sql
select count(*) as nr_apart from Apartament where tipul_apart='143' and regiune='Botanica'
```

7. Afişaţi valoarea maximală a câmpului “data_nast” din tabelul “comparator” a persoanelor numele cărora se începe cu litera “C”.

```sql
select max(data_de_nastere) as max_nast from Cumparator where nume like 'C%'
```

8. Afişaţivaloarea minimală a câmpului “pretul” a apartamentelor din regiunea “Botanica” cu nr_de_cam=3 de la etajul 5.

```sql
select min(pretul) as min_pret from Apartament where regiune='Botanica' and nr_de_cam=3 or nr_de_cam=5 and etaj=5
```

9. Afişaţi valoarea medie a preturilor pentru apartamentele din regiunea“Botanica” cu nr_de_cam=4.

```sql
select avg(pretul) as avg_pret from Apartament where regiune='Botanica' and nr_de_cam=4
```

10. Calculaţi câte apartamente  cu nr_de_cam=2 au pretul maximal.

```sql
select count(*) as num_max from Apartament where pretul=(select max(pretul) from Apartament) and nr_de_cam=2
```

11.  Calculaţi câte apartamente  cu nr_de_cam=2 aveţi, suma totala si media preturilor.

```sql
select count(*) as num_apart, sum(pretul) as sum_pret, avg(pretul) as avg_pret from Apartament where nr_de_cam=2
```

12. Calculaţi câte apartamente  din regiunea ce se începe cu litera “T” cu suprafata minimală aveţi. 

```sql
select count(*) as num_min from Apartament where suprafata=(select min(suprafata) from Apartament) and regiune like 'T%' 
```

13.  Afişaţi toate apartamentele  ignorându-le pe cele de la etajul 3 sau 4.

```sql
select * from Apartament where etaj!=3 and etaj!=4
```

14.  Afişaţi toate apartamentele  unde tipul_apart se începe cu litera “n”, iar suprafata este mai mare decât suprafata minimală a apartamentelor. 

```sql
select * from Apartament where tipul_apart like 'n%' and suprafata>(select min(suprafata) from Apartament)
```

### Alcătuiţi 10 sarcini la tema personală.(utilizaţi funcţiile agregat)

1. Numar de tranzactii cu feedback = 5.

```sql
select count(*) from Tranzactii where feedback=5
```

2. Numar de tranzactii cu feedback > 3.

```sql
select count(*) from Tranzactii where feedback>3
```

3. Numar de tranzactii unde feedback este mai mare decat feebackul mediu.

```sql
select count(*) as nr_feedback_mare from Tranzactii where feedback>(select avg(feedback) from Tranzactii)
```

4. Feedback > 3 si numarul de flori vandute > 5

```sql
select count(*) as nr_feedback_mare from Tranzactii where feedback>3 and numar_flori>5
```

5. Numarul de feedback-uri distincte.

```sql
select count(distinct feedback) as num_de_feeback from Tranzactii
```

6. Numarul de locatii distincte.

```sql
select count(distinct locatie) as num_de_locatii from Tranzactii
```

7. Numarul de locatii distincte care se termina cu `efan`.

```sql
select count(distinct locatie) as num_de_locatii from Tranzactii where locatie like '%efan'
```


## Lectia 8

1. Selectaţi toate apartamentele  de tipul ‘143’,’Moldova’ sau ‘102’. Ordonaţi această selecţie crescător după câmpul nr_de_cam. 

```sql
select * from Apartament where tipul_apart in ('143', 'Moldova', '102') order by nr_de_cam asc;
```

2. Selectaţi toţi cumpărării născuţi în anii 1980 sau 1987 din oraşul ‘Balti’ .Ordonaţi această selecţie crescător după câmpul data_nast. 

```sql
select * from Cumparator where extract(year from data_de_nastere) in (1980, 1987) and oras='Balti' order by data_de_nastere asc
```

3. Selectaţi toţi cumpărării la care numărul de telefon are primele cifre “060”şi sunt din orasul “Chisinau” sau “Balti”. Ordonaţi această selecţie decrescător dupăcâmpul nume. 

```sql
select * from Cumparator where telefon like '060%' and oras in ('Chisinau', 'Balti') order by nume desc
```

4. Selectaţi toate apartamentele  cu nr_de_balc egal cu 2 sau 3. Ordonaţi aceastăselecţie decrescător după câmpul cod. 

```sql
select * from Apartament where nr_de_balc in (2, 3) order by cod desc
```

5. Afişaţi toate apartamentele din regiunea “Centru”, “Botanica” sau “Buiucani” cu nr_de_cam mai mare ca 2. Ordonaţi această selecţie crescător după câmpul nr_de_cam. 

```sql
select * from Apartament where regiune in ('Centru', 'Botanica', 'Buiucani') and nr_de_cam=2 order by nr_de_cam desc
```

6. Selectaţi toţi cumpărării născuţi în lunile martie sau aprilie a anilor 1991,1985 sau 1980. Ordonaţi această selecţie crescător după câmpul data_nast. 

```sql
select * from Cumparator 
    where extract(year from data_de_nastere) between 1991 and 1985 
          and extract(month from data_de_nastere) in (2, 3)
          or extract(year from data_de_nastere)=1980 
          order by data_de_nastere asc
```

7. Afişaţi toate apartamentele cu suprafata>72,3, cu nr_de_balc=2 sau 3 si nr_de_cam=3 de tipul “143” sau “102”.

```sql
select * from Apartament
    where suprafata>72.3
          and nr_de_balc in (2, 3)
          and nr_de_cam=3
          and tipul_apart in ('143', '102')
```          

8. Afişaţi toţi cumpărătorii născuţi la data de 6 sau 9  din orasul “Chisinau” sau”Balti”. Ordonaţi această selecţie crescător după câmpul nume. 

```sql
select * from Cumparator
    where extract(day from data_de_nastere) in (6, 9)
          and oras in ('Balti', 'Chisinau')
          order by nume asc
```

9. Selectaţi numărul de cumpărători din fiecare oras.

```sql
select oras, count(*) from Cumparator group by oras
```

10. Selectaţi orasele unde numărul de cumpărători este >=2 .

```sql
select oras, count(*) from Cumparator group by oras having count(*) >= 2
```

11. Afişaţi câte apartamente la pret minimal sunt în fiecare regiune.

```sql
select regiune, count(*) as numar from Apartament 
    where pretul = (select min(pretul) from Apartament)
    group by regiune 
```

12. Afişaţi câte apartamente cu suprafata minimală sunt în fiecare regiune.

```sql
select regiune, count(*) as numar from Apartament 
    where suprafata = (select min(suprafata) from Apartament)
    group by regiune 
```

13. Afişaţi câţi cumpărători născuţi în anul 1980 sunt în fiecare oras.

```sql
select oras, count(*) as numar from Cumparator 
    where extract(year from data_de_nastere)=1980
    group by oras
```

14. Afişaţi câte apartamente de tipul “143” cu pretul<=43000 sunt în fiecare regiune.

```sql
select regiune, count(*) from Apartament 
    where pretul<=43000
    group by regiune
```

### Alcătuiţi 10 sarcini la tema personală. (utilizaţi: order by; operatorul in; group by şi having)

1. Numar de florarii in diferite orase.

```sql
select oras, count(*) from Florarie group by oras
```

2. Numar de florarii in diferite orase, ignorand orasele unde numarul de florarii este > 4.

```sql
select oras, count(*) from Florarie group by oras having count(cod) > 4
```

3. Arata codurile florariilor in ordinea descrescatoare. 

```sql
select cod from Florarie order by cod desc
```

4. Numar de tranzactii dupa feedback in ordinea crescatoare.

```sql
select feedback, count(*) from Tranzactii group by feedback order by feedback asc 
```

5. Numar de tranzactii dupa feedback, dar aratam numai feedback de 2, 3 si 4.

```sql
select feedback, count(*) from Tranzactii where feedback in (2, 3, 4) group by feedback
```

6. Numar de florarii din Chisinau.

```sql
select count(*) from Florarie where oras='Chisinau'
```

7. Numar de florarii dupa orasele Chisinau si Balti.

```sql
select oras, count(*) from Florarie where oras in ('Chisinau', 'Balti') group by oras
```

8. Numar de florarii dupa orasele Chisinau, Balti si Tiraspol.

```sql
select oras, count(*) from Florarie where oras in ('Chisinau', 'Balti', 'Tiraspol') group by oras
```

9. Numar de florarii din Chisinau unde anul fondarii este 1000, 2000 sau 3000.

```sql
select oras, count(*) from Florarie where oras='Chisinau' and extract(year from data_fondarii) in (1000, 2000, 3000) group by oras
```

## Lectia 9


1. Selectaţi câmpurile: cod din tabelul makler, nume din tabelul comparator, regiuneaşi tipul_apart din tabelul apartament, unde tipul_apart este “143” sau ”103” sau “ms”. (var.a si var.b cu inner join) 

```sql
select Makler.cod, Cumparator.nume, Apartament.regiune, Apartament.tipul_apart
from Makler 
inner join Apartament on Apartament.cod=Makler.cod_apart
inner join Cumparator on Cumparator.cod=Makler.cod_cump
where Apartament.tipul_apart in ('143', '103', 'ms', 'tip0')
```

2. Selectaţi câmpurile: cod,data_livr din tabelulmakler,nr_de_cam, etaj din tabelul apartamentşi numedin tabelul cumparator, unde nr_de_cam=3.Ordonaţi selecţia descrescător după câmpul data_livr. (var.a si var.b cu inner join) 

```sql
select Makler.cod, Makler.data_livr, Apartament.nr_de_cam, Apartament.etaj, Cumparator.nume
from Makler 
inner join Apartament on Apartament.cod=Makler.cod_apart
inner join Cumparator on Cumparator.cod=Makler.cod_cump
where Apartament.nr_de_cam = 3
order by Makler.data_livr desc
```

3. Selectaţi câmpurile: cod,comentarii din tabelulmakler,nr_de_cam, etaj din tabelul apartament, nume din tabelul cumparator, unde etaj=5 sau 4.Ordonaţi selecţia crescător după câmpul etaj.(inner join)

```sql
select Makler.cod, Makler.comentarii, Apartament.nr_de_cam, Apartament.etaj, Cumparator.nume
from Makler 
inner join Apartament on Apartament.cod=Makler.cod_apart
inner join Cumparator on Cumparator.cod=Makler.cod_cump
where Apartament.etaj in (4, 5)
order by Apartament.etaj asc
```

4. Selectaţi câmpurile: cod din tabelulmakler,regiune din tabelul apartament,data_nastşi nume din tabelul cu mparator, unde cumparatorii sunt născuti între anii 1978 si 1987. Ordonaţi selecţia crescător dupăcâmpu ldata_nast.( inner join ) 

```sql
select Makler.cod, Apartament.regiune, Cumparator.data_de_nastere, Cumparator.nume
from Makler 
inner join Apartament on Apartament.cod=Makler.cod_apart
inner join Cumparator on Cumparator.cod=Makler.cod_cump
where extract(year from Cumparator.data_de_nastere) between 1978 and 1987
order by Cumparator.data_de_nastere asc
```

5. Selectaţi câmpurile: cod,data_livr din tabela makler, nume, orasul din tabela cumparator, unde numele cumparatorului se incepe cu litera "V" si data_livr este din luna decembrie a anului 2004, din orasul "Chisinau"; (asociere din exterior spre stanga).

```sql
select Makler.cod, Makler.data_livr, Apartament.regiune, Cumparator.nume, Cumparator.oras
from Makler 
left join Apartament on Apartament.cod=Makler.cod_apart
left join Cumparator on Cumparator.cod=Makler.cod_cump
where Cumparator.nume like 'V%'
and extract(year from Makler.data_livr) = 2004
and extract(month from Makler.data_livr) = 11
and Cumparator.oras = 'Chisinau'
```

6. Selectaţi câmpurile:cod, data_livr din tabela makler1, regiunea, tipul_apart, pretul din tabela apartament, unde tipul_apart este "143" sau "nou", din regiunea "Telecentru" sau "Botanica" si data_livr din luna mai sau decembrie, iar pretul<=5400.( tabela de referinta este tab. din dreapta)

```sql
select Makler_1.cod, Makler_1.data_livr, Apartament.regiune, Apartament.tipul_apart, Apartament.pretul
from Makler_1
right join Apartament on Apartament.cod=Makler_1.cod_apart
where Apartament.tipul_apart in ('143', 'nou', 'tip0')
and Apartament.regiune in ('Telecentru', 'Botanica')
and extract(month from Makler_1.data_livr) in (4, 11)
and Apartament.pretul <= 5400
```

### Alcătuiţi 10 sarcini la tema personală. (utilizaţi: inner join, left outer join, right outer join)

1. Afisam toate tranzactii cu toate datele florariilor asociate.

```sql
select * 
from Tranzactii 
inner join Florarie on Tranzactii.florarie_cod=Florarie.cod
```

2. Afisam toate tranzactii cu toate datele Clientilor asociate.

```sql
select * 
from Tranzactii 
inner join Clienti on Tranzactii.client_cod=Clienti.cod
```

3. Afisam toate tranzactii cu toate datele Clientilor asociate utilizand left join.

```sql
select * 
from Tranzactii 
left join Clienti on Tranzactii.client_cod=Clienti.cod
```

4. Afisam toate tranzactii cu toate datele Clientilor asociate utilizand right join.

```sql
select * 
from Clienti 
right join Tranzactii on Clienti.cod=Tranzactii.client_cod
```

5. Afisam feedback si numele clientului care a lasat acest feedback pentru feedback > 3.

```sql
select Tranzactii.feedback, Clienti.nume 
from Tranzactii 
inner join Clienti on Clienti.cod=Tranzactii.client_cod
where feedback > 3
```

6. Afisam feedback mediu lasat de clienti, dupa cod client, daca este mai mare decat 2, unde floraria asociata nu este din Saratov.

```sql
select avg(Tranzactii.feedback), Clienti.cod 
from Tranzactii 
inner join Clienti on Clienti.cod=Tranzactii.client_cod
inner join Florarie on Florarie.cod=Tranzactii.florarie_cod
where Florarie.regiunea != 'Saratov'
group by Clienti.cod
having avg(Tranzactii.feedback) > 2
```

7. Afisam numele, prenumele si regiunea in care a fost efectuata tranzactia, unde feedback-ul lasat este 5.

```sql
select Clienti.nume, Clienti.prenume, Florarie.regiunea
from Tranzactii 
inner join Clienti on Clienti.cod=Tranzactii.client_cod
inner join Florarie on Florarie.cod=Tranzactii.florarie_cod
where Tranzactii.feedback = 5
```

8. Aratam codurile florariilor, clientilor si ale tranzactiilor, unde regiunea florariei nu este Saratov si numele clientului este Vasilie.

```sql
select Florarie.cod as Cod_Florarie, Clienti.cod as Cod_Clienti, Tranzactii.cod as Cod_Tranzactii
from Tranzactii 
inner join Clienti on Clienti.cod=Tranzactii.client_cod
inner join Florarie on Florarie.cod=Tranzactii.florarie_cod
where Florarie.regiunea != 'Saratov'
and Clienti.nume = 'Vasilie'
```

9. Aratam regiunea florariilor, orasul clientilor si locatiile tranzactiilor, unde regiunea florariei nu este Saratov si numele clientului este Vasilie.

```sql
select Florarie.regiunea, Cumparator.oras, Tranzactii.locatie
from Tranzactii 
inner join Cumparator on Cumparator.cod=Tranzactii.client_cod
inner join Florarie on Florarie.cod=Tranzactii.florarie_cod
where Florarie.regiunea != 'Saratov'
and Cumparator.nume = 'Vasilie'
```

10. Aratam regiunea florariilor, orasul clientilor si locatiile tranzactiilor, unde regiunea florariei nu este Saratov si numele clientului este Vasilie, ingorand primii 5 clienti.

```sql
select Florarie.regiunea, Cumparator.oras, Tranzactii.locatie
from Tranzactii 
inner join Cumparator on Cumparator.cod=Tranzactii.client_cod
inner join Florarie on Florarie.cod=Tranzactii.florarie_cod
where Florarie.regiunea != 'Saratov'
and Cumparator.nume = 'Vasilie'
and Cumparator.cod > 5
```

## Lectia 10


1. Selectaţi câmpurile:cod, data_livr din tab. makler1, regiunea, etaj, nr_de_cam din tab.apartament, data_nast,nume din tab.cumparator, unde cumparatorii sunt nascuti in anii 1980 sau 1987,regiunea "Botanica" sau "Telecentru",cu numele cumparatorului "Voda" sau "Georgescu" ordonaţi selecţia crescător după câmpul data_nast.(fol. inner join);

```sql
select Makler.cod, Makler.data_livr, 
    Apartament.regiune, Apartament.etaj, Apartament.nr_de_cam
from Makler 
inner join Apartament on Makler.cod_apart = Apartament.cod
inner join Cumparator on Makler.cod_cump = Cumparator.cod 
where 
    extract(year from Cumparator.data_de_nastere) in (1980, 1987)
    and Apartament.regiune in ('Botanica', 'Telecentru')
    and Cumparator.nume in ('Voda', 'Geoorgescu')
order by Cumparator.data_de_nastere asc
```

2. Afisaţi numarul de cumparatori din fiecare oras, ce au procurat apartamente cu 3 camere.(inner join)

```sql
select Cumparator.oras, count(Cumparator.cod)
from Makler 
inner join Apartament on Makler.cod_apart = Apartament.cod
inner join Cumparator on Makler.cod_cump = Cumparator.cod 
where Apartament.nr_de_cam = 3
group by Cumparator.oras
```

3. Selectati regiunile unde tipul apartamentelor procurate este “143” sau “nou”, iar numarul cumparatorilor >=3.(inner join)

```sql
select Apartament.regiune
from Makler 
inner join Apartament on Makler.cod_apart = Apartament.cod
inner join Cumparator on Makler.cod_cump = Cumparator.cod 
where Apartament.tipul_apart in ('143', 'nou') 
group by Apartament.regiune
having count(Cumparator.cod) >= 3
```

4. Afisaţi numarul de cumparatori din fiecare oras,ce au procurat apartamente la pret minimal.(inner join)

```sql
select Cumparator.oras, count(Cumparator.cod), Apartament.pretul
from Makler 
inner join Apartament on Makler.cod_apart = Apartament.cod
inner join Cumparator on Makler.cod_cump = Cumparator.cod 
where Apartament.pretul = (select min(pretul) from Apartament)
group by Cumparator.oras, Apartament.pretul
```

5. Returnaţi lista cumparatorilor, ce au procurat apartamente în regiunea "Ciocana".

```sql
select Cumparator.*
from Makler 
inner join Apartament on Makler.cod_apart = Apartament.cod
inner join Cumparator on Makler.cod_cump = Cumparator.cod 
where Apartament.regiune = 'Ciocana'
```

6. Returnaţi lista cumparatorilor, ce n-au procurat apartamente în regiunea "Ciocana".

```sql
select Cumparator.*
from Makler 
inner join Apartament on Makler.cod_apart = Apartament.cod
inner join Cumparator on Makler.cod_cump = Cumparator.cod 
where Apartament.regiune != 'Ciocana'
```

7. Creaţi o tabelă virtuală care prezentă datele despr e apartamentele din regiunea “Botanica” de tipul “143” sau “nou” si au pretul mai mic sau egal ca valoarea medie a preţurilor. 

```sql
create or replace view Sarcina7 as
(
    select *
    from Apartament
    where 
        regiune = 'Botanica'
        and tipul_apart in ('nou', '143') 
        and pretul <= (select avg(pretul) from Apartament)
)
```

### Alcătuiţi 10 sarcini la tema personală.(utilizaţi :inner join, tabele virtual si subinterogari exists)

1. Tabela virtuala din Clienti + Tranzactii.

```sql
create or replace view Sarcina8_1 as
(
    select Clienti.nume
    from Tranzactii
    inner join Clienti on Tranzactii.client_cod = Clienti.cod
)
```

2. Tabela virtuala din Clienti + Tranzactii, unde prenumele Clientului este Ion.

```sql
create or replace view Sarcina8_2 as
(
    select Clienti.nume
    from Tranzactii
    inner join Clienti on Tranzactii.client_cod = Clienti.cod
    where Clienti.prenume = 'Ion'
)
```

3. Tabela virtuala din Clienti + Tranzactii, unde prenumele Clientului este Ion si adresa este str.Stefan.

```sql
create or replace view Sarcina8_3 as
(
    select Clienti.nume
    from Tranzactii
    inner join Clienti on Tranzactii.client_cod = Clienti.cod
    where Clienti.prenume = 'Ion' and Clienti.adresa != 'str.Stefan'
)
```

4. Tabela virtuala din Clienti + Tranzactii, unde prenumele Clientului nu este Ion si adresa este str.Stefan iar pretul tranzactiei este > 20.

```sql
create or replace view Sarcina8_4 as
(
    select Clienti.nume
    from Tranzactii
    inner join Clienti on Tranzactii.client_cod = Clienti.cod
    where Clienti.prenume != 'Ion' and Clienti.adresa = 'str.Stefan' and Tranzactii.pret > 20
)
```

5. Tabela virtuala din Clienti + Tranzactii unde pretul tranzactiei este > 10.

```sql
create or replace view Sarcina8_5 as
(
    select Clienti.nume
    from Tranzactii
    inner join Clienti on Tranzactii.client_cod = Clienti.cod
    where Tranzactii.pret > 10
)
```

6. Aratam numele clientulor daca exista clientii cu prenumele Ion.

```sql
select nume
from Clienti
where exists (select nume from Clienti where Clienti.prenume != 'Ion'); 
```

7. Aratam numele clientulor daca exista clientii cu prenumele Nastica.

```sql
select prenume
from Clienti
where exists (select prenume from Clienti where Clienti.nume = 'Nastica'); 
```

8. Aratam numele clientulor daca exista clientii cu prenumele Nastea.

```sql
select prenume
from Clienti
where exists (select prenume from Clienti where Clienti.nume = 'Nastea'); 
```

## Lectia 11

1. Schimbam pretul la 11 daca exista cel putin o persoana cu numele Ion.

```sql
declare
pret_substitute Tranzactii.pret%type := 11;
nume_query Clienti.nume%type := 'Ion';
begin 
    update Tranzactii
    set Tranzactii.pret = pret_substitute
    where exists (
        select Clienti.cod 
        from Clienti 
        where Clienti.cod = Tranzactii.client_cod 
        and Clienti.nume = nume_query
    );
end;
```

2. Calculam suma de la i = 1 pana la 5, unde la fiecare iteratie x += i, y -= i, pentru valorile initiale x = 1, y = 2.

```sql
declare
x int := 1;
y int := 2;
begin 
    for i in 1..5 loop
        x := x + i;
        y := y - i;
    end loop;

    dbms_output.put_line('x = '||x);
    dbms_output.put_line('y = '||y);

end;
```

Output:

```
x = 16
y = -13
```

3. Afisam un triunghi de numere.

```sql
declare
x int := 1;
y int := 2;
begin 
    for i in 1..5 loop
        for j in 1..i loop
            dbms_output.put(j||' ');
        end loop;
        dbms_output.put_line('');
    end loop;
end;
```

Output:

```
1 
1 2 
1 2 3 
1 2 3 4 
1 2 3 4 5 
```

4. Afisam un triunghi dublu.

```sql
declare
x int := 1;
y int := 2;
begin 
    for i in 1..5 loop
        for j in 1..i loop
            dbms_output.put(j||' ');
        end loop;
        dbms_output.put_line('');
    end loop;
    for i in 1..5 loop
        for j in 1..(5-i) loop
            dbms_output.put(j||' ');
        end loop;
        dbms_output.put_line('');
    end loop;
end;
```

Output:

```
1 
1 2 
1 2 3 
1 2 3 4 
1 2 3 4 5 
1 2 3 4 
1 2 3 
1 2 
1
```

## Lectia 12

1. O functie simpla, care adauga doua numere.

```sql
create or replace function Add_Numbers(
    v_num_1 int,
    v_num_2 int
)
return int
is
begin
    return v_num_1 + v_num_2;
end;
```

Chemam cu 
```
dbms_output.put_line(Add_Numbers(1, 1));
```

Output: 
```
2
```

2. O procedura care gaseste si afiseaza numele si prenumele clientului avand cod.

```sql
create or replace procedure Print_Client_With_Code
(
    v_cod int
)
is
v_nume Clienti.nume%Type;
v_prenume Clienti.prenume%Type;
begin
    select nume, prenume 
    into v_nume, v_prenume 
    from Clienti
    where Clienti.cod = v_cod;

    if SQL%FOUND then
        dbms_output.put_line(v_nume||', '||v_prenume);
    else
        dbms_output.put_line('Not found');
    end if;
end;
```

Chemam cu 
```
Print_Client_With_Code(1);
```

Output: 
```
Vasilie, Ion
```

3. Functia care returneaza numele clientului avand cod.

```sql
create or replace function Get_Client_Name_By_Code
(
    v_cod int
)
return Clienti.nume%Type
is v_nume Clienti.nume%Type;
begin
    select nume
    into v_nume
    from Clienti
    where Clienti.cod = v_cod;

    return v_nume;
end;
```

Chemam cu 
```
Get_Client_Name_By_Code(1);
```

Output: 
```
Vasilie
```
