create database Scoala;
go

use Scoala;
go

create schema Scoala;
go

create table Scoala.Student(
    id                  int not null identity(1, 1),
    nume                nvarchar(128) not null,
    prenume             nvarchar(128) not null,
    data_de_nastere     date not null,
    
    constraint Student_PK
    primary key (id)
);

create table Scoala.Angajat(
    id                  int identity(1, 1) not null,
    nume                nvarchar(128) not null,
    prenume             nvarchar(128) not null,
    data_de_nastere     date not null,
    
    constraint Angajat_PK
    primary key (id)
);


create table Scoala.Functie(
    id           int identity(1, 1) not null,
    nume         nvarchar(128) not null,
    descriere    nvarchar(max) not null,

    -- Flaguri pentru filtrarea usoara a rezultatelor.
    profesor_bit    bit not null default 0,
    -- Rezervate pentru optimizari in viitor.
    reserverd_1_bit bit not null default 0,
    reserverd_2_bit bit not null default 0,
    reserverd_3_bit bit not null default 0,

    constraint Functie_PK
    primary key (id)
);

create table Scoala.AngajatFunctie(
    id int not null identity(1, 1),
    
    -- Lookup in tabelul Functie.
    functie_id int not null,

    angajat_id int not null,
    
    -- Data angajarii in aceasta functie.
    -- TODO: ensure it's sorted along with id, I don't know how.
    data_from date not null,

    -- Cand se schimba salariul, se creaza o noua inregistrare.
    salariu_pe_luna smallmoney not null,
    
    -- Data iesirii din acesta functie.
    -- Daca data este null, angajatul inca este angajat pentru acea functie.
    data_until date null default null, 

    constraint AngajatFunctie_PK
    primary key (id),

    constraint AngajatFunctie_FK_functie
    foreign key (functie_id)
    references Scoala.Functie (id),

    constraint AngajatFunctie_FK_angajat
    foreign key (angajat_id)
    references Scoala.Angajat (id)
);


create table Scoala.AngajatCualificatieInfo(
    id         int not null identity(1, 1),
    angajat_id int not null,

    -- Orice informatii, nerelevant pentru baze de date.
    descrierea_textuala nvarchar(max) not null,

    constraint AngajatCualificatieInfo_PK
    primary key (id),

    constraint AngajatCualificatieInfo_FK_angajat
    foreign key (angajat_id)
    references Scoala.Angajat (id)
);
go

create table Scoala.Obiect(
    id   int not null identity(1, 1),
    nume nvarchar(128) not null,

    -- TODO: ensure it's sorted along with id, I don't know how.
    semestru_de_prima_aparitie_offset smallint not null,
    
    -- Probabil in viata reala vom avea nevoie de mai multe date aici, ca la ce an de studii
    --  se corespunde obiectul, poate trebuie sa diferentiem obiecte si cursuri, etc.
    -- prim_an_de_studii_posibil tinyint,

    constraint Obiect_PK
    primary key (id),
);

create table Scoala.Clasa(
    id  int not null identity(1, 1),

    -- Indica de fapt anul + semestrul (1 sau 0) cand clasa a existat.
    -- Cand studentii trec intr-o clasa noua, aici se creeaza o noua inregistrare. 
    semestru_de_existenta_offset  smallint not null,

    -- Scrapped:
    -- Ar putea fi intr-un tabel aparte ClasaClasaPredecesor, dar asa tot e ok.
    -- Indica clasa din care clasa aceasta a fost creata.
    -- De exemplu, cand studentii din clasa 1A din anul 2011 trec in clasa 2A din anul 2012,
    -- s-ar crea o noua inregistrare de clasa pentru clasa 2A care va avea clasa 1A ca
    -- predecesorul sau.
    -- Clasele nu se sterg din tabele cand sunt inlocuite de clase noi,
    -- toate datele trecute sunt pastrate in baza de date.
    predecesor_clasa_id  int null,

    -- Scolii de obicei au 12 ani de invatamant, cate 2 semestre fiecare, deci acest camp
    -- poate fi intre 0 si 23 inclusiv.
    semestru_de_studii  tinyint not null,

    -- A, B, C etc
    litera  char(1) null,

    constraint Clasa_PK
    primary key (id),
    
    constraint Clasa_FK_predecesor_clasa
    foreign key (predecesor_clasa_id) references Scoala.Clasa(id),

    constraint Clasa_Range_semestru_de_studii
    check (semestru_de_studii >= 0 and semestru_de_studii <= 23)
);

create table Scoala.ProfesorObiectClasa(
    id          int not null identity(1, 1),
    angajat_id  int not null,
    obiect_id   int not null,
    clasa_id    int not null,

    -- In care semestru s-a predat obiectul dat.
    -- Se deduce usor din clasa.
    -- semestru_offset  smallint,

    constraint ProfesorObiect_PK
    primary key (id),
    
    constraint ProfesorObiect_FK_angajat
    foreign key (angajat_id)
    references Scoala.Angajat (id),
    
    constraint ProfesorObiect_FK_obiect
    foreign key (obiect_id)
    references Scoala.Obiect (id),
    
    constraint ProfesorObiect_FK_clasa
    foreign key (clasa_id)
    references Scoala.Clasa (id)
);

create table Scoala.ClasaStudent(
    id          int not null identity(1, 1),
    clasa_id    int not null,
    student_id  int not null,
    
    constraint ClasaStudent_PK
    primary key (id),

    constraint ClasaStudent_FK_clasa
    foreign key (clasa_id)
    references Scoala.Clasa (id),

    constraint ClasaStudent_FK_student
    foreign key (student_id)
    references Scoala.Student (id)
);

-- Toti studentii din clasa mereu sunt inscrisi la acelasi subiect.
-- La scoala lucreaza astfel, de aceea proiectam baza de date conform acestei constangeri.
-- create table Scoala.ClasaObiect(
--     id         int not null identity(1, 1),
--     clasa_id   int not null,
--     obiect_id  int not null,

--     constraint ClasaObiect_PK
--     primary key (id),

--     constraint ClasaObiect_FK_clasa
--     foreign key (clasa_id)
--     references Scoala.Clasa (id),

--     constraint ClasaObiect_FK_obiect
--     foreign key (obiect_id)
--     references Scoala.Obiect (id)
-- );

-- Tabelul acesta va fi cel mai incarcat din toate tabelele.
create table Scoala.Nota(
    id          int not null identity(1, 1),
    student_id  int not null,
    obiect_id   int not null,

    -- Nu am pus aici date, cu toate ca as putea utiliza date.
    -- Daca utilizez date, atunci ar trebuie sa mapam data la semestru.
    -- semestru_offset  smallint not null,

    -- O alta idee imi pare ca-i mai buna: vom utiliza id-ul clasei.
    -- Am putea si sa atribuim indici locali mai mici la obiectele si studentii asociati clasei,
    -- stocand aici doar acei indici locali, pentru a minimiza spatiul care ocupa acest tabel, dar
    -- atunci vom pierde si in performanta la accesari la note (sunt trade-offs peste tot).
    clasa_id  int not null,

    -- Vom face maparea la accesarea.
    numar_zi  tinyint not null,

    -- Valoarea numerica a notei
    valoarea  tinyint not null

    constraint Nota_PK
    primary key (id),

    constraint Nota_FK_student
    foreign key (student_id)
    references Scoala.Student (id),

    constraint Nota_FK_obiect
    foreign key (obiect_id)
    references Scoala.Obiect (id),

    constraint Nota_FK_clasa
    foreign key (clasa_id)
    references Scoala.Clasa (id),
    
    constraint Nota_Range_valoarea
    check (valoarea >= 0 and valoarea <= 9)
);

create table Scoala.Cheltuieli(
    id    int not null identity(1, 1),
    suma  smallmoney not null,
    note  nvarchar(max),

    constraint Cheltuieli_PK
    primary key (id)
);
go

create or alter function Scoala.GetYearSchoolStart()
returns smallint
as
begin
    return 2000;
end
go

create or alter function Scoala.GetStartDateOf_Semester_0(@an_studii smallint)
returns date
as
begin
    return datefromparts(@an_studii, 8, 1);
end
go

create or alter function Scoala.GetStartDateOf_Semester_1(@an_studii smallint)
returns date
as
begin
    return datefromparts(@an_studii + 1, 1, 7);
end
go

create or alter function Scoala.Map_AnSemestruOffset_To_SemestruActual(@semestru_offset smallint)
returns smallint
as
begin
    declare @year_school_start smallint = Scoala.GetYearSchoolStart();
    return @year_school_start + (@semestru_offset / 2);
end
go

create or alter function Scoala.Map_Date_To_AnSemestruOffset(@date date)
returns smallint
as
begin
    declare @year_school_start               smallint = Scoala.GetYearSchoolStart();
    declare @current_year                    smallint = year(@date);
    declare @current_year_offset             smallint = @current_year - @year_school_start;
    declare @semester_offset_at_current_year smallint = @current_year_offset * 2;

    if Scoala.GetStartDateOf_Semester_0(@current_year) > @date
        -- Anul de studii trecut se continuie in anul curent (anul real, data).
        return @semester_offset_at_current_year - 1;

    return @semester_offset_at_current_year;
end
go

create or alter function Scoala.Get_AnSemestruOffsetCurent()
returns smallint
as
begin
    declare @today date = getdate();
    return Scoala.Map_Date_To_AnSemestruOffset(@today);
end
go

create or alter function Scoala.Map_AnSemestruOffsetAndNumarZi_To_Date(@semestru_offset smallint, @numar_zi tinyint)
returns date
as
begin    
    declare @year_start   smallint = Scoala.Map_AnSemestruOffset_SemestruActual(@semestru_offset);
    declare @semestru_0_1 smallint = @semestru_offset % 2;
    declare @semestru_date_start date;
    
    if @semestru_0_1 = 0
        select @semestru_date_start = Scoala.GetStartDateOf_Semester_0(@year_start);
    else
        select @semestru_date_start = Scoala.GetStartDateOf_Semester_1(@year_start);
    
    -- DD means Day
    return dateadd(DD, @numar_zi, @semestru_date_start);
end
go

create or alter function Scoala.Map_AnSemestruOffset_SemestruActual(@semestru_offset smallint)
returns smallint
as
begin
    declare @year_school_start smallint = 2000;
    return @year_school_start + (@semestru_offset / 2);
end
go
