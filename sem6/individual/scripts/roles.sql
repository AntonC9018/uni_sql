use Scoala;

-- exec sp_addrole 'contabilitate';
create role contabilitate;


grant
    select,
    insert,
    -- O tranzacție ar putea fi actualizată, probabil, nu știu
    update,
    -- O tranzacție ar pute fi revocată, de aceea dăm și delete.
    delete
on Scoala.Cheltuieli
to contabilitate;


-- 2. *Administrator de recrutare* poate modifica datele referitoare la angajați (presupunem că directorul face recrutarea).
create role administrator_de_recrutare;

-- Nu ștergem niciodată din aceste tabele.
-- Pastrăm toata istorie, ea poate fi utilă.
grant select, insert, update
on Scoala.Angajat
to administrator_de_recrutare;

grant select, insert, update
on Scoala.AngajatCualificatieInfo
to administrator_de_recrutare;

grant select, insert, update
on Scoala.AngajatFunctie
to administrator_de_recrutare;

grant select, insert, update
on Scoala.Functie
to administrator_de_recrutare;


-- 2. *Administrator de admitere* poate modifica datele referitoare la studenți (presupunem că directorul admite studenții).
create role administrator_de_admitere;

-- De aici tot nu ștergem.
grant select, insert, update
on Scoala.Student
to administrator_de_admitere;


-- 4. *Administratorul de (atribuire a persoanelor la) clase* poate asocia studenți la clase, crea clasele noi.
create role administrator_de_clase;

grant select, insert
    -- În viața reală, probabil, ar trebui să permitem mutarea studenților
    -- dintr-o clasă în altă, deci aici tot am avea ca la angajați, o dată de
    -- intrare în funcție (în clasă) și o dată de ieșire.
    --, update
on Scoala.ClasaStudent
to administrator_de_clase;

grant select, insert, 
    -- În cazul în care se schimbă litera. Putem permite aceasta.
    update
on Scoala.Clasa
to administrator_de_clase;



create role administrator_de_profesori;

grant select, insert
    -- Nu se permite mutarea profesorilor la o altă clasă sau un alt obiect
    -- în același semestru. O clarificare: fiecare clasă există pentru un semestru,
    -- după aceasta devine istorică.
    -- , update
on Scoala.ProfesorObiectClasa
to administrator_de_profesori;


-- 3. *Profesor* poate adăuga notele în registrul electronic (tabelul Notele) (cu restricția aparținerii la clasa, dar nu realizez această constrângere).
create role profesor;

grant select, insert, update, delete
on Scoala.Nota
to profesor;

-- 5. *Examinator* poate crea examene și asocia note la examene la studenții pe care i-au predat.
-- 6. Altele (ceva cu obiectele, cu atribuirea profesorilor la cursuri, etc.).


create role public_introspection;

-- Eu zic că transparența este importantă.
grant select
on Scoala.Cheltuieli
to public_introspection;

grant select
on Scoala.Nota
to public_introspection;

grant select
on Scoala.Student
to public_introspection;

grant select
on Scoala.Clasa
to public_introspection;

grant select
on Scoala.ClasaStudent
to public_introspection;

grant select
on Scoala.ProfesorObiectClasa
to public_introspection;

grant select
on Scoala.Angajat
to public_introspection;

grant select
on Scoala.Functie
to public_introspection;

grant select
on Scoala.AngajatFunctie
to public_introspection;

grant select
on Scoala.AngajatCualificatieInfo
to public_introspection;

grant select
on Scoala.Obiect
to public_introspection;

