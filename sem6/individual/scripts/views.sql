
create or alter view Scoala.BugetulCurent
as 
    select sum(suma) as buget
    from Scoala.Cheltuieli;
go

create or alter view Scoala.ClasaStudenti_SemestrulCurent
as
    select
        (convert(nvarchar(max), clasa0.semestru_de_studii / 2) + clasa0.litera) as clasa,
        student.nume    as student_nume,
        student.prenume as student_prenume
    
    from Scoala.Student as student

    inner join Scoala.ClasaStudent as clasa_student
    on clasa_student.student_id = student.id

    inner join Scoala.Clasa as clasa0
    on clasa0.id = clasa_student.clasa_id

    where clasa0.semestru_de_existenta_offset = Scoala.Get_AnSemestruOffsetCurent()
go

create or alter view Scoala.NotaMedieStudentuluiLaObiect_SemestrulCurent
as
    select
        student.nume            as student_nume,
        student.prenume         as student_prenume,
        obiect.nume             as obiect_nume,
        avg(nota0.valoarea + 1) as nota_medie
    
    from Scoala.Student as student

    inner join Scoala.Nota as nota0
    on nota0.student_id = student.id

    inner join Scoala.Clasa as clasa0
    on clasa0.id = nota0.clasa_id

    inner join Scoala.Obiect as obiect
    on obiect.id = nota0.obiect_id

    where clasa0.semestru_de_existenta_offset = Scoala.Get_AnSemestruOffsetCurent()

    group by student.nume, student.prenume, obiect.nume
go


create or alter view Scoala.ProfesoriiAngajatiCurent
as
    select
        angajat.id       as angajat_id,
        angajat.nume     as profesor_nume,
        angajat.prenume  as profesor_prenume,
        string_agg(functie.nume, '; ')       as functii,
        sum(angajat_functie.salariu_pe_luna) as salariu_pe_luna
    
    from Scoala.Angajat as angajat

    inner join Scoala.AngajatFunctie as angajat_functie
    on angajat.id = angajat_functie.angajat_id

    inner join Scoala.Functie as functie
    on angajat_functie.functie_id = functie.id

    where 
        functie.profesor_bit = 1
        and angajat_functie.data_until is null
        -- and angajat_functie.data_from <= getdate()

    group by angajat.id, angajat.nume, angajat.prenume
go
