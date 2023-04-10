SET SERVEROUTPUT ON

SELECT *FROM libro2;

-- Procedimientos

CREATE OR REPLACE PROCEDURE ACTUALIZA_PRECIO(p_edit VARCHAR2)
IS
BEGIN
    UPDATE libro2
    SET precio = precio * 1.10
    WHERE editorial = p_edit;
END ACTUALIZA_PRECIO;

SELECT editorial, precio FROM libro2;

EXEC ACTUALIZA_PRECIO('Mc Graw Hill');

COMMIT; -- EN caso de ser necesario se necesita confirmar
SELECT editorial, precio FROM libro2;

DROP PROCEDURE ACTUALIZA_PRECIO;

CREATE OR REPLACE PROCEDURE
ACTUALIZA_PRECIO(p_edit VARCHAR2, p_inc NUMBER DEFAULT 10)
IS
BEGIN
    UPDATE libro2
    SET precio = precio * (1 + 0.01 * p_inc)
    WHERE editorial = p_edit;
END ACTUALIZA_PRECIO;

SELECT editorial, precio FROM libro2;

EXEC Actualiza_Precio('Iglesias', 20);

EXEC Actualiza_Precio('Progreso');

COMMIT;

CREATE TABLE autor_libro
(
    AUTOR VARCHAR2(50),
    TITULO VARCHAR2(50),
    EDITORIAL VARCHAR2(30),
    PRECIO NUMBER(7,2),
    PAGINAS NUMBER(4)
);

CREATE OR REPLACE PROCEDURE ANALIZA_AUTOR(p_autor VARCHAR2)
IS
BEGIN
    DELETE FROM autor_libro;
    COMMIT;
    INSERT INTO autor_libro
    SELECT * FROM libro2
    WHERE autor = p_autor;
    COMMIT;
END;

EXEC Analiza_Autor('Juan Lopez');

SELECT * FROM autor_libro;

CREATE OR REPLACE PROCEDURE ANALIZA_AUTOR(p_autor VARCHAR2)
IS sql_str VARCHAR2(1000);
BEGIN
    sql_str:='INSERT INTO autor_libro SELECT * FROM libro2 WHERE autor = :p_autor';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE autor_libro';
    EXECUTE IMMEDIATE sql_str USING p_autor;
    COMMIT;
END;

EXEC Analiza_Autor('Ian Roward');

SELECT * FROM autor_libro;

CREATE OR REPLACE PROCEDURE BAJA_AUTOR(p_autor VARCHAR2)
IS
BEGIN
    DELETE from libro2
    WHERE autor = p_autor;
    COMMIT;
END;

SELECT * FROM libro2;

EXEC Baja_Autor('Jorge Segura');

CREATE OR REPLACE PROCEDURE RENOMBRA_EDIT(p_EdAnt VARCHAR2, p_EdNva VARCHAR2) IS
sql_str VARCHAR2(1000);
    BEGIN
    sql_str:= 'UPDATE libro2 SET editorial = :p_EdNva WHERE editorial = :p_EdAnt';
    EXECUTE IMMEDIATE sql_str USING p_EdNva, p_EdAnt;
    COMMIT;
END;

EXEC RENOMBRA_EDIT('Pearson 1234','Oracle ProC');

SET SERVEROUTPUT OFF