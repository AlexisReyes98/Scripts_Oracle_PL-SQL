CREATE TABLE PACIENTES
(
    ID_PACIENTE NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(20),
    APELLIDO VARCHAR2(20),
    EDAD NUMBER(2),
    SEXO VARCHAR2(10),
    MOTIVO_CONSULTA VARCHAR2(50)
);

SELECT *FROM PACIENTES;

-- Inserte valores para probar el funcionamiento de la tabla
INSERT INTO PACIENTES VALUES(1,'Alexis','Reyes',23,'Masculino','Dolor de Estomago');
INSERT INTO PACIENTES VALUES(2,'Jessica','Vilchis',11,'Femenino','Dolor de Cabeza');

-- Procedimientos

CREATE OR REPLACE PROCEDURE BAJA_PACIENTE(ID_P NUMBER) IS
BEGIN
    DELETE FROM PACIENTES
    WHERE ID_PACIENTE = ID_P;
    COMMIT;
END;

EXEC BAJA_PACIENTE(1);  -- Para probar el procedimiento

CREATE OR REPLACE PROCEDURE CAMBIA_ID(id_Ant NUMBER, id_Nvo NUMBER) IS
sql_str VARCHAR2(1000);
    BEGIN
    sql_str:= 'UPDATE PACIENTES SET ID_PACIENTE = :id_Nvo WHERE ID_PACIENTE = :id_Ant';
    EXECUTE IMMEDIATE sql_str USING id_Nvo, id_Ant;
    COMMIT;
END;

EXEC CAMBIA_ID(1,15);  -- Para probar el procedimiento

-- Funciones

CREATE OR REPLACE FUNCTION PROM_EDAD(p_no NUMBER)
RETURN NUMBER AS
    v_total NUMBER;
BEGIN
    SELECT AVG(EDAD) INTO v_total
    FROM PACIENTES;
    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay registros');
    RETURN -1;
END;

SELECT PROM_EDAD(0) FROM dual;  -- Para probar la función

CREATE OR REPLACE FUNCTION PAGO_DESC(v_monto NUMBER)
RETURN NUMBER AS
    v_total NUMBER;
BEGIN
    v_total := v_monto - v_monto * 0.10;
    RETURN (v_total);
END;

SELECT PAGO_DESC(100) FROM dual;  -- Para probar la función
