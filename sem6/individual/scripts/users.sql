use Scoala;

-- 1. Directorul *Vasilie* are control asupra angajamentului, readonly la contabilitate, readonly la profesor, are control asupra distribuirii intre clase.
create role director;

alter role administrator_de_recrutare
add member director;

alter role administrator_de_admitere
add member director;

alter role administrator_de_clase
add member director;

alter role administrator_de_profesori
add member director;

alter role public_introspection
add member director;

create login director_vasilie_login
with
    password = '1111',
    default_database = Scoala;

create user director_vasilie_user
from login director_vasilie_login;

alter role director
add member director_vasilie_user;


-- 2. Contabilul *Gheorghe* are control asupra cheltuielilor.
create login contabil_gheorghe_login
with
    password = '1111',
    default_database = Scoala;

create user contabil_gheorghe_user
from login contabil_gheorghe_login;

alter role contabilitate
add member contabil_gheorghe_user;


-- 3. Profesoara *Mariana* are control asupra notelor la obiectul său, dar poate și crea examene pentru obiectul său.
create login profesor_mariana_login
with
    password = '1111',
    default_database = Scoala;

create user profesor_mariana_user
from login profesor_mariana_login;

alter role profesor
add member profesor_mariana_user;


