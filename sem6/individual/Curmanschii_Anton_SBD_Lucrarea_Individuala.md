Tema: **Școală**.

> 1\. De descris activitatea entității economice/sociale/de învățământ.

- Predă lecții studenților.
- Angajează profesorii pentru predare a temelor.
- Administrează bugetul. Școala poate fi susținută de guvern sau una privată. În această lucrare se consideră o școală susținută de guvern.
- Realizează testarea studenților conform standardelor naționale. Realizează examinarea obligatorie.
- Realizează olimpiade și concursuri interne pentru selectarea studenților care pretind să participe în concursuri la nivel de raion.
- Realizează evenimente publice, ca primul apel.


> 2\. De stabilit scopul realizării Bazei de Date.

Baza de date este necesară pentru stocarea listei studenților, obiectelor, profesoarelor, notelor la lecții și la examene, rezultatelor la olimpiade, informații contabile.


> 3\. De proiectat Baza de Date (cel puțin 8 tabele) și de evidențiat potențialii utilizatori ai BD.

Utilizatorii:

- *Profesorii* care înscriu notele în catalog;
- *Părinții* care vor să găsească notele copiilor săi;
- *Administrarea contabilă* care administrează cheltuielile de buget de la guvern (начисление бюджета), cheltuielile din partea școlii (reparații, actualizarea echipamentelor pentru predare);
- *Publicul* care dorește să cunoască despre studenții eminenți.


Tabelele:
1. Studenții(nume, prenume, anul nasterii), clasa fiind id-ul;
2. Angajații(nume, prenume, anul nasterii, rol);
3. ProfesorCualificatieInfo(Angajat -> anul de studii, Informații despre cualificatia profesorului);
4. ProfesorCePreda(Profesor -> obiect, clasa), anul de studii se deduce usor din clasa;
5. Cheltuielile(sursa, suma, data);
6. Clasa(an de studii, anul epocii, numar, profesorul de clasa); 
7. ClasaStudentiiInfo(Clasa -> Student);
7. StudentObiectInfo(Student -> Obiect);
8. ExamenNotele(student, examen, nota);
9. Examen(nume, obiect, data), clasa asociată poate fi aflată după orice student care a susținut examenul, anul de studii tot;
10. Obiectele(nume);
11. Notele(student, obiect, nota, data);

Sunt necesare și mai multe tabele, dar este dificil de a le concepe fără a avea o problemă reală în față.


```


```




> 4\. De argumentat și de creat 3 identificatori și respectiv 3 utilizatori.


Rolurile:

1. *Contabilitate* poate modifica datele referitoare la cheltuieli.
2. *Administrator de angajare* poate modifica datele referitoare la studenții și angajații (presupunem că directorul face recrutarea).
3. *Profesor* poate adăuga notele în registrul electronic (tabelul Notele) (cu restricția aparținerii la clasa, dar nu realizez aceasta).
4. *Administratorul de (atribuire a persoanelor la) clase* poate asocia studenți la clasele, crea clasele noi.
5. *Examinator* poate crea examene și asocia note la examene la studenții pe care i-au predat.
6. Altele (ceva cu obiectele, cu atribuirea profesorilor la cursuri, etc.).


Utilizatorii:

1. Directorul *Vasilie* are acces la angajament, readonly la contabilitate, readonly la profesor, are acces la distribuirea intre clase.
2. Contabilul *Gheorghe* are acces la contabilitate.
3. Profesoara *Mariana* are acces la note la obiectul său, dar poate și crea examene pentru obiectul său.


> 5\. De implementat restricțiile NOT NULL, UNIQUE, CHECK, PRIMARY KEY și FOREIGN KEY.

> 6\. Creați 3 vederi:
1) care conține coloane din două tabele;
2) care conține coloane din 3 tabele;
3) care conține coloane din 3 tabele cu condiții de filtrare a conținutului coloanelor.

> 7\. Setați la nivelul unei tabele auditul la modificarea datelor (Insert, Update, Delete).

> 8\. Setați la nivel de BD auditul logon, auditul activității DDL, auditul erorilor, auditul modificării privilegiilor și utilizatorilor.

> 9\. Elaborați unui plan de creare a copiilor de rezervă și restabilire a datelor având în vedere specificul BD realizate.