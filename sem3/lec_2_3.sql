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