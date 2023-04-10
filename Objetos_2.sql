SET SERVEROUTPUT ON

-- Problema 1
CREATE OR REPLACE TYPE Punto AS OBJECT (
    eje_X REAL,
    eje_Y REAL,
    MEMBER FUNCTION to_string_cartesianas RETURN String,
    MEMBER FUNCTION to_string_polares RETURN String
);

CREATE OR REPLACE TYPE BODY Punto AS
    MEMBER FUNCTION to_string_cartesianas RETURN String IS
    BEGIN
        RETURN '(' || eje_X || ', ' || eje_Y || ')';
    END to_string_cartesianas;
    -- Coordenadas cartesianas (x,y) a Coordenadas polares (r,θ)
    MEMBER FUNCTION to_string_polares RETURN String IS
        ejePolar_X REAL;
        ejePolar_Y REAL;
    BEGIN
        ejePolar_X := SQRT(POWER(eje_X, 2) + POWER(eje_Y, 2));  -- r = √ (x^2 + y^2)
        ejePolar_Y := ATAN(eje_Y / eje_X) * 57.2958;  -- θ = atan(y / x), fórmula de conversión de 1 radian = 57.2958 grados. 
        RETURN '(' || TRUNC(ejePolar_X, 2) || ', ' || TRUNC(ejePolar_Y, 2) || '°)'; -- TRUNC(N, M): Trunca N hasta la posición M a la derecha del punto decimal.
    END to_string_polares;
END;

DECLARE
    op Punto;
BEGIN
    op := Punto(12, 5);
    DBMS_OUTPUT.PUT_LINE('Coordenadas Cartesianas: ' || op.to_string_cartesianas);
    DBMS_OUTPUT.PUT_LINE('Coordenadas Polares: ' || op.to_string_polares);
    DBMS_OUTPUT.PUT_LINE(' ');
    op := Punto(3, 4);
    DBMS_OUTPUT.PUT_LINE('Coordenadas Cartesianas: ' || op.to_string_cartesianas);
    DBMS_OUTPUT.PUT_LINE('Coordenadas Polares: ' || op.to_string_polares);
END;

-- Problema 2
CREATE OR REPLACE TYPE Fecha AS OBJECT (
    v_date DATE,
    MEMBER FUNCTION fecha_abreviada RETURN String,
    MEMBER FUNCTION fecha_extendida RETURN String,
    MEMBER FUNCTION incremento (numD NUMERIC) RETURN String
);

CREATE OR REPLACE TYPE BODY Fecha AS
    -- Formato: (16/02/2000)
    -- TO_CHAR(datetime): convierte una expresión de intervalo o de fecha y hora en una cadena de texto en un formato especificado.
    MEMBER FUNCTION fecha_abreviada RETURN String IS
    BEGIN
        RETURN TO_CHAR(v_date, 'DD/MM/YYYY');
    END fecha_abreviada;
    -- Formato: (16 de febrero de 2000)
    MEMBER FUNCTION fecha_extendida RETURN String IS
    BEGIN
        RETURN TO_CHAR(v_date, 'DD') || ' de ' || TO_CHAR(v_date, 'MONTH', 'NLS_DATE_LANGUAGE = Spanish') || ' de ' || TO_CHAR(v_date, 'YYYY');
    END fecha_extendida;
    MEMBER FUNCTION incremento (numD NUMERIC) RETURN String IS
        v_date2 DATE := SYSDATE;
    BEGIN
        v_date2 := v_date2+numD;
        RETURN TO_CHAR(v_date2, 'DD/MM/YYYY');
    END incremento;
END;

DECLARE
    fec Fecha;
    numD NUMERIC := &NumDias;
BEGIN
    fec := Fecha(SYSDATE);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('La fecha abreviada es: ' || fec.fecha_abreviada);
    DBMS_OUTPUT.PUT_LINE('La fecha extendida es: ' || fec.fecha_extendida);
    DBMS_OUTPUT.PUT_LINE('La fecha incrementada en el número de dias escrito es: ' || fec.incremento(numD));
END;

-- Problema 3
CREATE OR REPLACE TYPE numComplejo AS OBJECT (
    parte_r REAL,
    parte_i REAL,
    MEMBER FUNCTION suma (x numComplejo) RETURN numComplejo,
    MEMBER FUNCTION resta (x numComplejo) RETURN numComplejo,
    MEMBER FUNCTION modulo (x numComplejo) RETURN numComplejo
);

CREATE OR REPLACE TYPE BODY numComplejo AS
    MEMBER FUNCTION suma (x numComplejo) RETURN numComplejo IS
    BEGIN
        RETURN numComplejo(parte_r + x.parte_r, parte_i + x.parte_i);
    END suma;
    MEMBER FUNCTION resta (x numComplejo) RETURN numComplejo IS
    BEGIN
        RETURN numComplejo(parte_r - x.parte_r, parte_i - x.parte_i);
    END resta;
    MEMBER FUNCTION modulo (x numComplejo) RETURN numComplejo IS
    BEGIN
        RETURN numComplejo(Mod(parte_r, x.parte_r), Mod(parte_i, x.parte_i));
    END modulo;
END;

CREATE TABLE operComplejo (
    oper NUMBER,
    comp numComplejo
);

INSERT INTO operComplejo VALUES(1, numComplejo(4, 6));
INSERT INTO operComplejo VALUES(2, numComplejo(5, 7));
INSERT INTO operComplejo VALUES(3, numComplejo(4, 9));

select oc.oper, oc.comp.parte_r, oc.comp.parte_i from operComplejo oc;

DECLARE
    comp numComplejo;
BEGIN
    select oc.comp.suma(numComplejo(2, 3)) INTO comp from operComplejo oc
        where oc.oper = 1;
    DBMS_OUTPUT.PUT_LINE(' Suma: ');
    DBMS_OUTPUT.PUT_LINE(' Resultado imaginario: ' || comp.parte_r);
    DBMS_OUTPUT.PUT_LINE(' Resultado real: ' || comp.parte_i);
    DBMS_OUTPUT.PUT_LINE(' ------------------------------------ ');
    select oc.comp.resta(numComplejo(2, 3)) INTO comp from operComplejo oc
        where oc.oper = 2;
    DBMS_OUTPUT.PUT_LINE(' Resta: ');
    DBMS_OUTPUT.PUT_LINE(' Resultado imaginario: ' || comp.parte_r);
    DBMS_OUTPUT.PUT_LINE(' Resultado real: ' || comp.parte_i);
    DBMS_OUTPUT.PUT_LINE(' ------------------------------------ ');
    select oc.comp.modulo(numComplejo(2, 3)) INTO comp from operComplejo oc
        where oc.oper = 3;
    DBMS_OUTPUT.PUT_LINE(' Modulo: ');
    DBMS_OUTPUT.PUT_LINE(' Resultado imaginario: ' || comp.parte_r);
    DBMS_OUTPUT.PUT_LINE(' Resultado real: ' || comp.parte_i);
END;

-- Poblema 4
CREATE OR REPLACE TYPE Coeficientes IS VARRAY(3) OF INTEGER;

CREATE OR REPLACE TYPE Polinomio AS OBJECT (
    coef Coeficientes,
    MEMBER FUNCTION suma (b Polinomio) RETURN Polinomio
);

CREATE OR REPLACE TYPE BODY Polinomio AS
    MEMBER FUNCTION suma (b Polinomio) RETURN Polinomio IS
    TYPE nArray IS VARRAY(3) OF INTEGER;
    v_nArray nArray;
    x Polinomio;
    BEGIN
        v_nArray := nArray(0, 0, 0);
        x := Polinomio(v_nArray);
        FOR i IN 1..3 LOOP
            x.coef(i) := x.coef(i) + coef(i);
        END LOOP;
        FOR i IN 1..3 LOOP
            x.coef(i) := x.coef(i) + b.coef(i);
        END LOOP;
        RETURN x;
    END suma;
END;

DECLARE
    TYPE nArray IS VARRAY(3) OF INTEGER;
    v_nArray nArray;
    v_nArray2 nArray;
    coeficientesP Polinomio;
BEGIN
    v_nArray := nArray(1, 2, 3); 
    coeficientesP := Polinomio(v_nArray);
    v_nArray2 := nArray(5, 0, 3);
    DBMS_OUTPUT.PUT_LINE(' p(x) = ' || v_nArray);
    DBMS_OUTPUT.PUT_LINE(' q(x) = ' || v_nArray2);
    DBMS_OUTPUT.PUT_LINE(' f(x) = p(x) + q(x) = ' || coeficientesP.suma(v_nArray2));
END;

-- Problema 5
CREATE OR REPLACE TYPE Empleados AS OBJECT (
    nombre VARCHAR2(30),
    fec Fecha,
    salario REAL,
    MEMBER FUNCTION getEmpleado RETURN String
);

CREATE OR REPLACE TYPE BODY Empleados AS
    MEMBER FUNCTION getEmpleado RETURN String IS
    BEGIN
        RETURN 'Nombre: ' || nombre || ' Fecha de consulta: ' || fec.fecha_abreviada || ' Salario de: ' || salario;
    END getEmpleado;
END;

DECLARE
    nombre VARCHAR2(30) := 'Giovanny Reyes';
    salario REAL := 5500.50;
    fec Fecha;
    emp Empleados;
BEGIN
    fec := Fecha(SYSDATE);
    emp := Empleados(nombre, fec, salario);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Empleado:');
    DBMS_OUTPUT.PUT_LINE(emp.getEmpleado);
END;

-- Problema 6
CREATE TABLE Ventas (
    mes VARCHAR2(30),
    nombre VARCHAR2(30),
    valor REAL
);

INSERT INTO Ventas VALUES('Enero', 'Venta 1', 1527.20);
INSERT INTO Ventas VALUES('Febrero', 'Venta 2', 954.70);
INSERT INTO Ventas VALUES('Marzo', 'Venta 3', 674.20);
INSERT INTO Ventas VALUES('Abril', 'Venta 4', 3140.30);
INSERT INTO Ventas VALUES('Mayo', 'Venta 5', 1547.20);
INSERT INTO Ventas VALUES('Junio', 'Venta 6', 2036.20);
INSERT INTO Ventas VALUES('Julio', 'Venta 7', 1505.10);
INSERT INTO Ventas VALUES('Agosto', 'Venta 8', 597.40);
INSERT INTO Ventas VALUES('Septiembre', 'Venta 9', 1177.20);
INSERT INTO Ventas VALUES('Octubre', 'Venta 10', 2144.80);
INSERT INTO Ventas VALUES('Noviembre', 'Venta 11', 2036.90);
INSERT INTO Ventas VALUES('Diciembre', 'Venta 12', 3025.75);

select *from Ventas;

CREATE OR REPLACE TYPE Registro AS OBJECT (
    v_totalVentas NUMERIC,
    v_totalValor REAL,
    MEMBER FUNCTION totalVentas RETURN NUMERIC,
    MEMBER FUNCTION totalValor RETURN REAL
);

CREATE OR REPLACE TYPE BODY Registro AS
    MEMBER FUNCTION totalVentas RETURN NUMERIC IS
    v_ventas NUMERIC;
    BEGIN
        SELECT COUNT(mes) INTO v_ventas FROM Ventas;
        RETURN v_ventas;
    END totalVentas;
    MEMBER FUNCTION totalValor RETURN REAL IS
    v_valor REAL;
    BEGIN
        SELECT SUM(valor) INTO v_valor FROM Ventas;
        RETURN v_valor;
    END totalValor;
END;

DECLARE
    reg Registro;
BEGIN
    reg := Registro(0, 0);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Total de ventas: ' || reg.totalVentas);
    DBMS_OUTPUT.PUT_LINE('Valor total de las ventas realizadas: ' || reg.totalValor);
END;

SET SERVEROUTPUT OFF