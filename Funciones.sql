SET SERVEROUTPUT ON

SELECT *FROM libro2;

-- Funciones

CREATE OR REPLACE FUNCTION precio_desc(p_autor VARCHAR2)
RETURN NUMBER AS
    v_total NUMBER(7,2);
    v_precio NUMBER(7,2);
BEGIN
    SELECT precio INTO v_precio
    FROM libro2
    WHERE autor LIKE p_autor;
    RETURN v_precio - v_precio * 0.50;
END precio_desc;

DECLARE
    valor NUMBER;
BEGIN
    valor := precio_desc('Juana Arco');
    DBMS_OUTPUT.PUT_LINE('Valor con descuento: ' || valor);
END;

SELECT precio_desc('Juana Arco') FROM DUAL;

DECLARE
    valor NUMBER;
BEGIN
    valor := precio_desc('Juan Lopez');
    DBMS_OUTPUT.PUT_LINE('Valor con descuento: ' || valor);
END;

SELECT precio_desc('Juan Morales') FROM DUAL;

CREATE OR REPLACE FUNCTION precio_desc(p_autor VARCHAR2)
RETURN NUMBER AS
    v_total NUMBER(7,2);
    v_precio NUMBER(7,2);
BEGIN
    SELECT precio INTO v_precio
    FROM libro2
    WHERE autor LIKE p_autor;
RETURN v_precio - v_precio * 0.50;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Mas de un registro');
        RETURN -1;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay registros');
        RETURN -2;
END precio_desc;

DECLARE
    valor NUMBER;
BEGIN
    valor := precio_desc('Juan Lopez');
    DBMS_OUTPUT.PUT_LINE('Valor con descuento: ' || valor);
END;

SELECT precio_desc('Juan Morales') FROM DUAL;

CREATE OR REPLACE FUNCTION COSTO_POR_EDITORIAL(p_edit VARCHAR2)
RETURN NUMBER AS
    v_total NUMBER;
BEGIN
    SELECT SUM(precio) INTO v_total
    FROM libro2
    WHERE editorial = p_edit;
    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay registros');
    RETURN -1;
END;

DECLARE
    v_valor NUMBER;
BEGIN
    v_valor := COSTO_POR_EDITORIAL('Mc Graw Hill');
    DBMS_OUTPUT.PUT_LINE('Valor: ' || v_valor);
END;

-- Ejecutar para estas ambas funciones
DECLARE
    v_valor NUMBER;
BEGIN
    v_valor := COSTO_POR_EDITORIAL('Pearson');
    DBMS_OUTPUT.PUT_LINE('Valor: ' || v_valor);
END;

CREATE OR REPLACE FUNCTION COSTO_POR_EDITORIAL(p_edit VARCHAR2)
RETURN NUMBER AS
    v_total NUMBER;
BEGIN
    SELECT SUM(precio) INTO v_total
    FROM libro2
    WHERE editorial = p_edit
    GROUP BY 1;
    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay registros');
    RETURN -1;
END;

CREATE OR REPLACE FUNCTION factorial(n NUMBER)
RETURN NUMBER AS
    acum NUMBER := 1;
    i NUMBER := 1;
BEGIN
    LOOP
        IF (i <= n) THEN
            acum := acum * i;
            i := i + 1;
        ELSE
            EXIT;
        END IF;
    END LOOP;
    RETURN(acum);
END;

SELECT FACTORIAL(6) FROM dual;

CREATE OR REPLACE FUNCTION CALC_IVA(p_prec FLOAT)
RETURN FLOAT IS
    v_iva FLOAT;
BEGIN
    v_iva := p_prec * 0.16;
    return(v_iva);
END;

SELECT precio, CALC_IVA(precio)
FROM libro2;

CREATE OR REPLACE FUNCTION ID_AUTOR(p_aut VARCHAR2)
RETURN NUMBER IS
    v_idAut NUMBER := 0;
BEGIN
    IF ( p_aut = 'Juan Lopez') THEN
        v_idAut := 1001;
    ELSIF ( p_aut = 'Ian Roward') THEN
        v_idAut := 1002;
    ELSIF ( p_aut = 'Mary Janes') THEN
        v_idAut := 1003;
    ELSIF ( p_aut = 'Jorge Segura') THEN
        v_idAut := 1004;
    ELSIF ( p_aut = 'Juana Arco') THEN
        v_idAut := 1005;
    ELSIF( p_aut = 'Netz Romero') THEN
        v_idAut := 1006;
    END IF;
    RETURN(v_idAut);
END;

SELECT autor, ID_AUTOR(autor)
FROM libro2;

DROP FUNCTION ID_AUTOR;

SET SERVEROUTPUT OFF