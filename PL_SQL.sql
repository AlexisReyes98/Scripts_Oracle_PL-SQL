SET SERVEROUTPUT ON

DECLARE
    var VARCHAR2(10);
BEGIN
    var := 'hola mundo 15';
    DBMS_OUTPUT.PUT_LINE('Salida: '|| var);
END;

DECLARE
    v_var1 number := 10;
    v_var2 number := 20;
    v_var3 number;
BEGIN
    v_var3 := v_var1 + v_var2;
    DBMS_OUTPUT.PUT_LINE('La suma de las variables es: ' || v_var3);
END;

DECLARE
    v_date DATE := SYSDATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('La fecha es: ' || v_date );
END;

DECLARE
    v_point_x1 DECIMAL(6,2) := -3;
    v_point_x2 DECIMAL(6,2) := 2;
    v_point_y1 DECIMAL(6,2) := 5;
    v_point_y2 DECIMAL(6,2) := 8;
    v_distance DECIMAL(6,2);
BEGIN
    v_distance := SQRT(POWER((v_point_x1-v_point_x2),2)+POWER((v_point_y1-v_point_y2),2));
    DBMS_OUTPUT.PUT_LINE('Calcula la distancia de dos puntos');
    DBMS_OUTPUT.PUT_LINE('Punto X : (' || v_point_x1||','||v_point_x2||')');
    DBMS_OUTPUT.PUT_LINE('Punto Y : (' || v_point_y1||','||v_point_y2||')');
    DBMS_OUTPUT.PUT_LINE('Distancia XY : ' || v_distance);
END;

DECLARE
    valor NUMBER(3);
BEGIN
    valor := 20;
    IF valor > 10 THEN
        DBMS_OUTPUT.PUT_LINE('Valor mayor que 10');
    END IF;
END;

DECLARE
    v_dia VARCHAR2(15);
    v_fecha DATE := TO_DATE('09-MAR-2022', 'DD-MON-YYYY');
BEGIN
    v_dia := RTRIM(TO_CHAR(v_fecha, 'DAY'));
    IF v_dia IN ('SATURDAY', 'SUNDAY') THEN
        DBMS_OUTPUT.PUT_LINE (v_fecha || 'cae en fin de semana');
    END IF;
        DBMS_OUTPUT.PUT_LINE ('El día es un: ' || v_dia);
END;

DECLARE
    v_random NUMBER(4) := TRUNC(DBMS_RANDOM.VALUE(1,1000));
BEGIN
    DBMS_OUTPUT.PUT_LINE('El numero: ' || v_random);
    IF mod(v_random, 2) = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Es impar');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Es par');
    END IF;
END;

DECLARE
    v_random NUMBER(3) := TRUNC(DBMS_RANDOM.VALUE(1,100));
BEGIN
    IF (v_random < 33) THEN
        dbms_output.put_line('El valor es menor a 33');
    ELSIF (v_random <= 66) THEN
        DBMS_OUTPUT.PUT_LINE('El valor esta entre 34 y 66');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El valor es mayor a 67');
    END IF;
        DBMS_OUTPUT.PUT_LINE('El valor es: ' || v_random);
END;

DECLARE
    v_calif CHAR(2);
BEGIN
    v_calif := 'MB';
    CASE v_calif
        WHEN 'MB' THEN DBMS_OUTPUT.PUT_LINE('Muy Bien');
        WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Bien');
        WHEN 'S' THEN DBMS_OUTPUT.PUT_LINE('Suficiente');
        WHEN 'NA' THEN DBMS_OUTPUT.PUT_LINE('No Acreditado');
        ELSE DBMS_OUTPUT.PUT_LINE('No existe calificacion');
    END CASE;
END;

DECLARE
    v_counter INTEGER := 0;
BEGIN
    LOOP
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE('v_counter = ' || v_counter);
        IF v_counter = 5 THEN
            EXIT;
        END IF;
    END LOOP;
END;

DECLARE
    acum NUMBER(5);
    i NUMBER(5) := 1;
    n NUMBER(5) := 6;
BEGIN
    acum := 1;
    LOOP
        IF (i <= n) THEN
            acum := acum * i;
            i := i + 1;
        ELSE
            EXIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('El factorial de 6 es: ' || acum);
END;

DECLARE
    v_counter NUMBER := 5;
BEGIN
    WHILE v_counter > 0 LOOP
        DBMS_OUTPUT.PUT_LINE ('v_counter = ' || v_counter);
        v_counter := v_counter - 1;
    END LOOP;
END;

DECLARE
    i NUMBER(5);
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('i: ' || i);
    END LOOP;
END;

DECLARE
    i NUMBER(5);
BEGIN
    FOR i IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('i: ' || i);
    END LOOP;
END;

DECLARE
    v_counter BINARY_INTEGER := 0;
BEGIN
    LOOP
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE('Antes CONTINUE, v_counter = ' || v_counter);
        IF v_counter < 3 THEN
            CONTINUE;
        END IF;
            DBMS_OUTPUT.PUT_LINE('Despues CONTINUE, v_counter = ' || v_counter);
        IF v_counter = 5 THEN
            EXIT;
        END IF;
    END LOOP;
END;

DECLARE
    v_counter1 INTEGER := 0;
    v_counter2 INTEGER;
BEGIN
    WHILE v_counter1 < 3 LOOP
        DBMS_OUTPUT.PUT_LINE ('v_counter1: ' || v_counter1);
        v_counter2 := 0;
        LOOP
            DBMS_OUTPUT.PUT_LINE ('v_counter2: ' || v_counter2);
            v_counter2 := v_counter2 + 1;
            EXIT WHEN v_counter2 >= 2;
        END LOOP;
        v_counter1 := v_counter1 + 1;
    END LOOP;
END;

SET SERVEROUTPUT OFF
