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