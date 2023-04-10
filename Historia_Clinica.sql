CREATE TABLE HISTORIA_CLINICA
(
    ID_PACIENTE NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(20),
    APELLIDO VARCHAR2(20),
    EDAD NUMBER(2),
    SEXO VARCHAR2(10),
    DOMICILIO VARCHAR(50),
    HEREDITARIOS_FAMILIARES VARCHAR(50),
    PADECIMIENTO_ACTUAL VARCHAR(50),
    CLAVE_INSTITUCION NUMBER(1),
    MEDICO_ASIGNADO VARCHAR(50)
);

SELECT * FROM HISTORIA_CLINICA;

-- Inserte valores para probar el funcionamiento de la tabla
INSERT INTO HISTORIA_CLINICA VALUES(1,'Alexis','Reyes',23,'Masculino','Cuajimalpa 1784','Ninguna','Dolor de Cabeza',3,'Dra. Maria Carmen');
INSERT INTO HISTORIA_CLINICA VALUES(2,'Jessica','Vilchis',11,'Femenino','Cuajimalpa 1474','Ninguna','Gripe',3,'Dr. Jorge');
INSERT INTO HISTORIA_CLINICA VALUES(3,'Bryan','Reyes',22,'Masculino','Cuajimalpa 1206','Ninguna','Fractura de Hombro',3,'Dr. Felipe');
INSERT INTO HISTORIA_CLINICA VALUES(4,'Valeria','Ramirez',23,'Femenino','Santa Lucia 1340','Diabetes','Dolor de Estomago',7,'Dr. Mario');
INSERT INTO HISTORIA_CLINICA VALUES(5,'Luis','Rodriguez',27,'Masculino','Santa Fe 0127','Ninguna','Fratura de Pie Izquierdo',8,'Dr. Mauricio');

-- Cabezera del paquete
CREATE OR REPLACE PACKAGE gest_clinica AS
CURSOR c_paciente RETURN historia_clinica%ROWTYPE;
PROCEDURE inserta_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_nombre historia_clinica.nombre%TYPE,
    v_apellido historia_clinica.apellido%TYPE,
    v_edad historia_clinica.edad%TYPE,
    v_sexo historia_clinica.sexo%TYPE,
    v_domicilio historia_clinica.domicilio%TYPE,
    v_hereditario historia_clinica.hereditarios_familiares%TYPE,
    v_padecimiento historia_clinica.padecimiento_actual%TYPE,
    v_clave_inst historia_clinica.clave_institucion%TYPE,
    v_medico historia_clinica.medico_asignado%TYPE);

PROCEDURE baja_paciente(v_id_paciente NUMBER);

PROCEDURE modificar_edad_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_edad historia_clinica.edad%TYPE);

PROCEDURE modificar_domicilio_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_domicilio historia_clinica.domicilio%TYPE);

PROCEDURE modificar_pad_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_padecimiento historia_clinica.padecimiento_actual%TYPE);

PROCEDURE modificar_clave_inst_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_clave_inst historia_clinica.clave_institucion%TYPE);

PROCEDURE modificar_medico_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_medico historia_clinica.medico_asignado%TYPE);

PROCEDURE visualizar_datos_paciente(v_id_paciente historia_clinica.id_paciente%TYPE);

PROCEDURE visualizar_datos_paciente(v_nombre historia_clinica.nombre%TYPE);

PROCEDURE calcula_prom_edad(v_edades NUMBER);

PROCEDURE aplica_desc_paciente(v_cantidad NUMBER);
END gest_clinica;

-- Creación del cuerpo del paquete
CREATE OR REPLACE PACKAGE BODY gest_clinica AS
CURSOR c_paciente RETURN historia_clinica%ROWTYPE
IS SELECT * FROM historia_clinica;
FUNCTION buscar_paciente_por_nombre(nombre_paciente VARCHAR2)
RETURN NUMBER;

PROCEDURE inserta_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_nombre historia_clinica.nombre%TYPE,
    v_apellido historia_clinica.apellido%TYPE,
    v_edad historia_clinica.edad%TYPE,
    v_sexo historia_clinica.sexo%TYPE,
    v_domicilio historia_clinica.domicilio%TYPE,
    v_hereditario historia_clinica.hereditarios_familiares%TYPE,
    v_padecimiento historia_clinica.padecimiento_actual%TYPE,
    v_clave_inst historia_clinica.clave_institucion%TYPE,
    v_medico historia_clinica.medico_asignado%TYPE)
IS
BEGIN
    INSERT INTO HISTORIA_CLINICA VALUES (v_id_paciente, v_nombre, v_apellido,
    v_edad, v_sexo, v_domicilio, v_hereditario, v_padecimiento, v_clave_inst, v_medico);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error ID de paciente duplicado');
END inserta_paciente;

PROCEDURE baja_paciente(v_id_paciente NUMBER) IS
BEGIN
    DELETE FROM HISTORIA_CLINICA
    WHERE ID_PACIENTE = v_id_paciente;
    COMMIT;
END baja_paciente;

PROCEDURE modificar_edad_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_edad historia_clinica.edad%TYPE)
IS
BEGIN
    UPDATE HISTORIA_CLINICA SET EDAD = v_edad
    WHERE ID_PACIENTE = v_id_paciente;
END modificar_edad_paciente;

PROCEDURE modificar_domicilio_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_domicilio historia_clinica.domicilio%TYPE)
IS
BEGIN
    UPDATE HISTORIA_CLINICA SET DOMICILIO = v_domicilio
    WHERE ID_PACIENTE = v_id_paciente;
END modificar_domicilio_paciente;

PROCEDURE modificar_pad_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_padecimiento historia_clinica.padecimiento_actual%TYPE)
IS
BEGIN
    UPDATE HISTORIA_CLINICA SET PADECIMIENTO_ACTUAL = v_padecimiento
    WHERE ID_PACIENTE = v_id_paciente;
END modificar_pad_paciente;

PROCEDURE modificar_clave_inst_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_clave_inst historia_clinica.clave_institucion%TYPE)
IS
BEGIN
    UPDATE HISTORIA_CLINICA SET CLAVE_INSTITUCION = v_clave_inst
    WHERE ID_PACIENTE = v_id_paciente;
END modificar_clave_inst_paciente;

PROCEDURE modificar_medico_paciente(
    v_id_paciente historia_clinica.id_paciente%TYPE,
    v_medico historia_clinica.medico_asignado%TYPE)
IS
BEGIN
    UPDATE HISTORIA_CLINICA SET MEDICO_ASIGNADO = v_medico
    WHERE ID_PACIENTE = v_id_paciente;
END modificar_medico_paciente;

PROCEDURE visualizar_datos_paciente(v_id_paciente historia_clinica.id_paciente%TYPE)
IS
    reg_paciente historia_clinica%ROWTYPE;
BEGIN
    SELECT * INTO reg_paciente FROM HISTORIA_CLINICA WHERE ID_PACIENTE = v_id_paciente;
    DBMS_OUTPUT.PUT_LINE('ID del Paciente: '|| reg_paciente.ID_PACIENTE);
    DBMS_OUTPUT.PUT_LINE('Nombre: '|| reg_paciente.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('Apellido: '|| reg_paciente.APELLIDO);
    DBMS_OUTPUT.PUT_LINE('Edad: '|| reg_paciente.EDAD);
    DBMS_OUTPUT.PUT_LINE('Sexo: '|| reg_paciente.SEXO);
    DBMS_OUTPUT.PUT_LINE('Domicilio: '|| reg_paciente.DOMICILIO);
    DBMS_OUTPUT.PUT_LINE('Hereditarios Familiares: '|| reg_paciente.HEREDITARIOS_FAMILIARES);
    DBMS_OUTPUT.PUT_LINE('Clave de la Institucuón: '|| reg_paciente.CLAVE_INSTITUCION);
    DBMS_OUTPUT.PUT_LINE('Medico Asignado: '|| reg_paciente.MEDICO_ASIGNADO);
END visualizar_datos_paciente;

PROCEDURE visualizar_datos_paciente(v_nombre historia_clinica.nombre%TYPE)
IS
    v_id_paciente historia_clinica.id_paciente%TYPE;
    reg_paciente historia_clinica%ROWTYPE;
BEGIN
    v_id_paciente := buscar_paciente_por_nombre(v_nombre);
    SELECT * INTO reg_paciente FROM HISTORIA_CLINICA WHERE ID_PACIENTE = v_id_paciente;
    DBMS_OUTPUT.PUT_LINE('ID del Paciente: '|| reg_paciente.ID_PACIENTE);
    DBMS_OUTPUT.PUT_LINE('Nombre: '|| reg_paciente.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('Apellido: '|| reg_paciente.APELLIDO);
    DBMS_OUTPUT.PUT_LINE('Edad: '|| reg_paciente.EDAD);
    DBMS_OUTPUT.PUT_LINE('Sexo: '|| reg_paciente.SEXO);
    DBMS_OUTPUT.PUT_LINE('Domicilio: '|| reg_paciente.DOMICILIO);
    DBMS_OUTPUT.PUT_LINE('Hereditarios Familiares: '|| reg_paciente.HEREDITARIOS_FAMILIARES);
    DBMS_OUTPUT.PUT_LINE('Clave de la Institucuón: '|| reg_paciente.CLAVE_INSTITUCION);
    DBMS_OUTPUT.PUT_LINE('Medico Asignado: '|| reg_paciente.MEDICO_ASIGNADO);
END visualizar_datos_paciente;

-- Función local
FUNCTION buscar_paciente_por_nombre(nombre_paciente VARCHAR2)
RETURN NUMBER
IS
    id_p historia_clinica.id_paciente%TYPE;
BEGIN
    SELECT ID_PACIENTE INTO id_p FROM HISTORIA_CLINICA WHERE NOMBRE = nombre_paciente;
    RETURN id_p;
END buscar_paciente_por_nombre;

PROCEDURE calcula_prom_edad(v_edades NUMBER) IS
    v_total NUMBER;
BEGIN
    SELECT AVG(EDAD) INTO v_total
    FROM HISTORIA_CLINICA;
    DBMS_OUTPUT.PUT_LINE('El promedio de edad de los pacientes actuales es: ' || v_total);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No hay registros');
END calcula_prom_edad;

PROCEDURE aplica_desc_paciente(v_cantidad NUMBER) IS
    v_total NUMBER;
BEGIN
    v_total := v_cantidad - v_cantidad * 0.10;
    DBMS_OUTPUT.PUT_LINE('Cantidad a cobrar al paciente: $' || v_cantidad);
    DBMS_OUTPUT.PUT_LINE('Nueva cantidad a pagar del paciente: $' || v_total);
END;
END gest_clinica;