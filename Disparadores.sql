SET SERVEROUTPUT ON

-- Disparadores

CREATE TABLE orders (
    somecolumn VARCHAR2(20),
    numbercol NUMBER(10),
    datecol DATE
);

SELECT * FROM orders;

-- Se crea el disparador
CREATE OR REPLACE TRIGGER statement_level
BEFORE UPDATE
ON orders
DECLARE
    vMsg VARCHAR2(30) := 'Statement Level Trigger Fired';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vMsg);
END statement_level;

INSERT INTO orders (somecolumn) VALUES ('ABC');

UPDATE orders SET somecolumn = 'XYZ';

CREATE OR REPLACE TRIGGER statement_level
AFTER INSERT OR UPDATE OR DELETE
ON orders
DECLARE
    vMsg VARCHAR2(30) := 'Statement Level Trigger Fired';
BEGIN
    IF INSERTING THEN
    DBMS_OUTPUT.PUT_LINE(vMsg || ' When Inserting');
    ELSIF UPDATING THEN
    DBMS_OUTPUT.PUT_LINE(vMsg || ' When Updating');
    ELSIF DELETING THEN
    DBMS_OUTPUT.PUT_LINE(vMsg || ' When Deleting');
    END IF;
END statement_level;

INSERT INTO orders (somecolumn) VALUES ('ABC');

UPDATE orders SET somecolumn = 'XYZ';

DELETE FROM orders WHERE ROWNUM = 1;

DROP TRIGGER statement_level;   -- ELiminar Disparador

TRUNCATE TABLE orders;  -- Limpiar registros de la tabla

CREATE OR REPLACE TRIGGER row_level
BEFORE UPDATE
ON orders
FOR EACH ROW
DECLARE
    vMsg VARCHAR2(30) := 'Row Level Trigger Fired';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vMsg);
END;

INSERT INTO orders (somecolumn) VALUES ('111');
INSERT INTO orders (somecolumn) VALUES ('222');
INSERT INTO orders (somecolumn) VALUES ('333');

UPDATE orders SET somecolumn = '123';

CREATE OR REPLACE TRIGGER of_clause
BEFORE UPDATE
OF numbercol
ON orders
FOR EACH ROW
DECLARE
    vMsg VARCHAR2(40) := 'Update Will Change numbercol Column';
BEGIN
    DBMS_OUTPUT.PUT_LINE(vMsg);
END of_clause;

SELECT * FROM orders;

UPDATE orders
SET datecol = SYSDATE;

UPDATE orders
SET numbercol = 8;

CREATE TABLE empleado (
    nombre varchar2(50),
    depto varchar2(50),
    salario number(6)
);

CREATE OR REPLACE TRIGGER tr1_empleado
    AFTER INSERT
    ON empleado
DECLARE
BEGIN
    UPDATE empleado
    SET salario = 5000
    WHERE depto = 'ventas'
    AND salario > 5000;
END;

INSERT INTO empleado values ('juan', 'sistemas', 15000);
INSERT INTO empleado values ('paco', 'soporte', 10000);
INSERT INTO empleado values ('maria', 'ventas', 4000);
INSERT INTO empleado values ('carlos', 'ventas', 6000);
INSERT INTO empleado values ('juana', 'ventas', 8000);

SELECT * FROM empleado;

CREATE TABLE mensajes
(
    mensaje VARCHAR2(500),
    fecha date
);

CREATE OR REPLACE TRIGGER tr2_empleado
    AFTER INSERT OR UPDATE OF salario
    ON empleado
    FOR EACH ROW
    WHEN (new.salario > 18000)
DECLARE
BEGIN
    INSERT INTO mensajes VALUES ('Salario muy alto de ' || :new.nombre || ' avisar a gerencia', SYSDATE);
END;

INSERT INTO empleado values ('alberto', 'soporte', 7000);
INSERT INTO empleado values ('diana', 'soporte', 20000);
INSERT INTO empleado values ('luis', 'ventas', 19000);

SELECT * FROM mensajes;

SET SERVEROUTPUT OFF