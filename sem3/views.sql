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