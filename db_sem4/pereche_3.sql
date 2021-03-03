PROMPT Type BookList...
CREATE OR REPLACE TYPE BookList AS VARRAY(10) OF NUMBER(4);
/

PROMPT Table class_material...
CREATE TABLE class_material (
  department       CHAR(3),
  course           NUMBER(3),
  required_reading BookList
);
/

REM This script illustrates DML operations on tables with collection
REM columns.

-- Clear the tables first.
DELETE FROM class_material;
/
DELETE FROM library_catalog;
/

-- This block illustrates several INSERT statements into
-- class_material.  At the end of this block, class_material will
-- look like Figure 14-1.
DECLARE
    v_CSBooks BookList := BookList(1000, 1001, 1002);
    v_HistoryBooks BookList := BookList(2001);
BEGIN
    -- INSERT using a newly constructed varray of 2 elements.
    INSERT INTO class_material
        VALUES ('MUS', 100, BookList(3001, 3002));
        
    -- INSERT using a previously initialized varray of 3 elements.
    INSERT INTO class_material VALUES ('CS', 102, v_CSBooks);

    -- INSERT using a previously initialized varray of 1 element.
    INSERT INTO class_material VALUES ('HIS', 101, v_HistoryBooks);
END;
/




CREATE TABLE books (
    catalog_number NUMBER(4)     PRIMARY KEY,
    title          VARCHAR2(40),
    author1        VARCHAR2(40),
    author2        VARCHAR2(40),
    author3        VARCHAR2(40),
    author4        VARCHAR2(40)
);
/

INSERT INTO books (catalog_number, title, author1)
    VALUES (1000, 'Oracle8i Advanced PL/SQL Programming',
                  'Urman, Scott');

INSERT INTO books (catalog_number, title, author1, author2, author3)
    VALUES (1001, 'Oracle8i: A Beginner''s Guide',
                  'Abbey, Michael', 'Corey, Michael J.',
                  'Abramson, Ian');

INSERT INTO books (catalog_number, title, author1, author2, author3, author4)
    VALUES (1002, 'Oracle8 Tuning',
                  'Corey, Michael J.', 'Abbey, Michael',
                  'Dechichio, Daniel J.', 'Abramson, Ian');

INSERT INTO books (catalog_number, title, author1, author2)
    VALUES (2001, 'A History of the World',
                  'Arlington, Arlene', 'Verity, Victor');

INSERT INTO books (catalog_number, title, author1)
    VALUES (3001, 'Bach and the Modern World', 'Foo, Fred');

INSERT INTO books (catalog_number, title, author1)
    VALUES (3002, 'Introduction to the Piano',
                  'Morenson, Mary');

PROMPT Type StudentList...
CREATE OR REPLACE TYPE StudentList AS TABLE OF NUMBER(5);
/

PROMPT Table library_catalog...
CREATE TABLE library_catalog (
    catalog_number NUMBER(4),
        FOREIGN KEY (catalog_number) REFERENCES books(catalog_number),
    num_copies     NUMBER,
    num_out        NUMBER,
    checked_out    StudentList
)
NESTED TABLE checked_out STORE AS co_tab;


-- This block illustrates several UPDATE statements on 
-- library_catalog.  At the end of this block, library_catalog will
-- look like Figure 14-2.
DECLARE
    v_StudentList1 StudentList := StudentList(10000, 10002, 10003);
    v_StudentList2 StudentList := StudentList(10000, 10002, 10003);
    v_StudentList3 StudentList := StudentList(10000, 10002, 10003);
BEGIN
    -- First insert rows with NULL nested tables.
    INSERT INTO library_catalog (catalog_number, num_copies, num_out)
        VALUES (1000, 20, 3);
    INSERT INTO library_catalog (catalog_number, num_copies, num_out)
        VALUES (1001, 20, 3);
    INSERT INTO library_catalog (catalog_number, num_copies, num_out)
        VALUES (1002, 10, 3);
    INSERT INTO library_catalog (catalog_number, num_copies, num_out)
        VALUES (2001, 50, 0);
    INSERT INTO library_catalog (catalog_number, num_copies, num_out)
        VALUES (3001, 5, 0);
    INSERT INTO library_catalog (catalog_number, num_copies, num_out)
        VALUES (3002, 5, 1);
    
    -- Now update using the PL/SQL variables.
    UPDATE library_catalog
        SET checked_out = v_StudentList1
        WHERE catalog_number = 1000;
    UPDATE library_catalog
        SET checked_out = v_StudentList2
        WHERE catalog_number = 1001;
    UPDATE library_catalog
        SET checked_out = v_StudentList3
        WHERE catalog_number = 1002;

  -- And update the last row using a new nested table.
    UPDATE library_catalog
        SET checked_out = StudentList(10009)
        WHERE catalog_number = 3002;
END;
/
COMMIT;

-- Here we delete a row
-- Remove the book "Bach and the Modern World" from the
-- library catalog.
DELETE FROM library_catalog
    WHERE catalog_number = 3001;

-- Rollback to leave the tables like the figures.
ROLLBACK;

