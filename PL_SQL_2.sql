SET SERVEROUTPUT ON

-- Solución al problema 1
DECLARE
    v_kilogramos NUMBER := &kilogramos;
    v_libras NUMBER := 0;
    v_onzas NUMBER := 0;
BEGIN
    v_libras := v_kilogramos * 2.20462; -- 1kg = 2.20462 lib
    v_onzas := v_kilogramos * 35.274;   -- 1kg = 35.274 oz
    DBMS_OUTPUT.PUT_LINE('kilogramos introducidos: ' || v_kilogramos || ' kg');
    DBMS_OUTPUT.PUT_LINE('Valor en libras: ' || v_libras || ' lbs');
    DBMS_OUTPUT.PUT_LINE('VAlor en onzas: ' || v_onzas || ' oz');
END;

-- Solución al problema 2
DECLARE
    a NUMBER := &valor1;
    b NUMBER := &valor2;
    c NUMBER := &valor3;
BEGIN
    IF (c > b AND b > a) THEN
        DBMS_OUTPUT.PUT_LINE('El orden ascendente es el siguiente: ' || a || ' ' || b || ' ' || c);
    ELSIF (a > b AND b > c) THEN
        DBMS_OUTPUT.PUT_LINE('El orden ascendente es el siguiente: ' || c || ' ' || b || ' ' || a);
    ELSIF (a > b AND c > a) THEN
        DBMS_OUTPUT.PUT_LINE('El orden ascendente es el siguiente: ' || b || ' ' || a || ' ' || c);
    ELSIF (a > c AND c > b) THEN
        DBMS_OUTPUT.PUT_LINE('El orden ascendente es el siguiente: ' || b || ' ' || c || ' ' || a);
    ELSIF (b > c AND b > a AND a > c) THEN
        DBMS_OUTPUT.PUT_LINE('El orden ascendente es el siguiente: ' || c || ' ' || a || ' ' || b);
    ELSE
        DBMS_OUTPUT.PUT_LINE('El orden ascendente es el siguiente: ' || a || ' ' || c || ' ' || b);
    END IF;
END;

-- Solución al problema 3
CREATE OR REPLACE FUNCTION factoriales(numero NUMBER)
RETURN NUMBER IS
BEGIN
    IF (numero = 0) THEN
        RETURN 1;
    ELSE
        RETURN numero * factoriales(numero-1);
    END IF;
END;

DECLARE
    v_n INTEGER := &n;
    v_e NUMBER := 0;
BEGIN
    FOR i IN 0..v_n LOOP
        v_e := v_e + 1/factoriales(i);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Resultado de la Serie con N = ' || v_n || ' es: ' || v_e);
END;

-- Solución al problema 4
-- Nota: Para la conversión se utilizaron valores actuales de las monedas
DECLARE
    v_pesos NUMBER := &pesos;
    v_letra VARCHAR2(2) := '&letra';
    v_n NUMBER;
BEGIN
    IF (v_letra = 'y') THEN
        v_n := v_pesos * 5.88;  -- $1 = 5.88 yenes
        DBMS_OUTPUT.PUT_LINE('El valor en pesos de: ' || v_pesos || ' equivale a: ' || v_n || ' yenes');
    ELSIF (v_letra = 'd') THEN
        v_n := v_pesos * 0.049; -- $1 = 0.049 dólares
        DBMS_OUTPUT.PUT_LINE('El valor en pesos de: ' || v_pesos || ' equivale a: ' || v_n || ' dolares');
    ELSIF (v_letra = 'e') THEN
        v_n := v_pesos * 0.045; -- $1 = 0.045 euros
        DBMS_OUTPUT.PUT_LINE('El valor en pesos de: ' || v_pesos || ' equivale a: ' || v_n || ' euros');
    ELSIF (v_letra = 's') THEN
        v_n := v_pesos * 0.19;  -- $1 = 0.19 nuevos soles
        DBMS_OUTPUT.PUT_LINE('El valor en pesos de: ' || v_pesos || ' equivale a: ' || v_n || ' nuevos soles');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al escribir el tipo de moneda...');
    END IF;
END;

-- Solución al problema 5
DECLARE
    v_clave NUMBER;
    acceso NUMBER := 123;
    v_count INTEGER := 0;
BEGIN
    LOOP
        v_clave := &clave;
        v_count := v_count + 1;
        IF (v_clave = acceso) THEN
            DBMS_OUTPUT.PUT_LINE('Clave correcta!!!');
            EXIT;
        ELSIF (v_count <= 3) THEN
            DBMS_OUTPUT.PUT_LINE('Clave incorrecta, intento ' || v_count || ' de 3');
            CONTINUE;
        ELSIF (v_count = 4) THEN
            DBMS_OUTPUT.PUT_LINE('Clave incorrecta, itentos superados');
            EXIT;
        END IF;
    END LOOP;
END;

-- Solución al problema 6
DECLARE
    v_n NUMBER := &n;
    serie NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('La serie hasta el número ' || v_n || ' es: ');
    FOR i IN 1..v_n LOOP
        DBMS_OUTPUT.PUT_LINE(serie);
        IF (MOD(i,2) != 0) THEN
            serie := serie+4;
        ELSE
            serie := serie-2;
        END IF;
    END LOOP;
END;

-- Solución al problema 7
DECLARE
    v_x NUMBER := &x;
    v_n NUMBER := &n;
    suma NUMBER := 0;
    elevado NUMBER;
BEGIN
    FOR i IN 0..v_n LOOP
        elevado := POWER(v_x, i);
        suma := suma+elevado;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Resultado de la suma: ' || suma);
END;

-- Solución al problema 8
DECLARE
    v_n INTEGER := &n;
    mult INTEGER := 0;
BEGIN
    FOR i IN 1..10 LOOP
        mult := i*v_n;
        DBMS_OUTPUT.PUT_LINE(v_n || ' X ' || i || ' = ' || mult);
    END LOOP;
END;

-- Solución al problema 9
DECLARE
    v_filas INTEGER := &filas;
BEGIN
    FOR altura IN 1..v_filas LOOP   -- Determina el número de filas
        FOR blancos IN 1..(v_filas-altura) LOOP   -- Determina los espacios en blanco
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
        FOR asteriscos IN 1..(altura*2)-1 LOOP   -- Imprime los asteriscos 
            DBMS_OUTPUT.PUT_LINE('*');
        END LOOP;
    END LOOP;
END;

-- Solución al problema 10
DECLARE
    v_numero INTEGER := &numero;
BEGIN
    IF (MOD(v_numero,2) != 0) THEN
        DBMS_OUTPUT.PUT_LINE('El número ' || v_numero || ' es impar');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El número ' || v_numero || ' es par');
    END IF;
END;

-- Solución al problema 11
DECLARE
    v_ropa NUMBER := &ropa;
    v_cosmeticos NUMBER := &cosmeticos;
    v_perfumeria NUMBER := &perfumeria;
    descuento NUMBER;
    v_total NUMBER;
BEGIN
    IF (v_ropa > 100) THEN
        descuento := 5/100;
        descuento := v_ropa*descuento;
        v_ropa := v_ropa-descuento;
        DBMS_OUTPUT.PUT_LINE('El nuevo monto después del descuento en ropa es: ' || v_ropa);
    ELSE
        DBMS_OUTPUT.PUT_LINE('El monto a pagar en ropa es: ' || v_ropa);
    END IF;
    IF (v_cosmeticos > 100) THEN
        descuento := 3.5/100;
        descuento := v_cosmeticos*descuento;
        v_cosmeticos := v_cosmeticos-descuento;
        DBMS_OUTPUT.PUT_LINE('El nuevo monto después del descuento en cosmeticos es: ' || v_cosmeticos);
    ELSE
        DBMS_OUTPUT.PUT_LINE('El monto a pagar en cosmeticos es: ' || v_cosmeticos);
    END IF;
    IF (v_perfumeria > 100) THEN
        descuento := 8/100;
        descuento := v_perfumeria*descuento;
        v_perfumeria := v_perfumeria-descuento;
        DBMS_OUTPUT.PUT_LINE('El nuevo monto después del descuento en perfumeria es: ' || v_perfumeria);
    ELSE
        DBMS_OUTPUT.PUT_LINE('El monto a pagar en perfumeria es: ' || v_perfumeria);
    END IF;
    v_total := v_ropa + v_cosmeticos + v_perfumeria;
    DBMS_OUTPUT.PUT_LINE('El monto total a pagar es de: ' || v_total);
END;

-- Solución al problema 12
DECLARE
    TYPE v_numeros IS VARRAY(5) OF INTEGER;  -- Array de tipo entero
    digitos v_numeros;
    elementos INTEGER;
    ban INTEGER := 1;
    prom NUMBER := 0;
BEGIN
    -- EL número a ingresar tiene que ser separado por comas, ejemplo: 28
    -- Se tiene que ingresar: 2,8
    digitos := v_numeros(&numero);
    elementos := digitos.count;
    IF elementos = 2 THEN
        DBMS_OUTPUT.PUT_LINE('El número tiene dos dígitos');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El número No tiene dos dígitos');
    END IF;
    FOR i IN 1..elementos LOOP
        IF (MOD(digitos(i),2) != 0) THEN
            ban := 0;
        END IF;
    END LOOP;
    IF (ban = 1) THEN
        DBMS_OUTPUT.PUT_LINE('Los dígitos del número son pares');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Los dígitos del número No son pares');
    END IF;
    FOR i IN 1..elementos LOOP
        prom := prom + digitos(i);
    END LOOP;
    prom := prom/elementos;
    DBMS_OUTPUT.PUT_LINE('El promedio de los dígitos es: ' || prom);
END;

-- Solución al problema 13
DECLARE
    -- Registro para los valores de cada fila
    TYPE a_array IS RECORD(
        num1 INTEGER,
        num2 INTEGER,
        num3 INTEGER);
     -- Tabla para generar la matriz (mxn)
    TYPE a_matriz IS TABLE OF a_array INDEX BY BINARY_INTEGER;
    v_matriz a_matriz;  -- Matriz final
    elementos INTEGER;
BEGIN
    v_matriz(1).num1 := 6;
    v_matriz(1).num2 := 4;
    v_matriz(1).num3 := 2;
    v_matriz(2).num1 := 9;
    v_matriz(2).num2 := 8;
    v_matriz(2).num3 := 7;
    v_matriz(3).num1 := 3;
    v_matriz(3).num2 := 5;
    v_matriz(3).num3 := 1;
    elementos := v_matriz.count;
    DBMS_OUTPUT.PUT_LINE('Matriz Original:');
    FOR i IN 1..elementos LOOP
        DBMS_OUTPUT.PUT_LINE(v_matriz(i).num1 || ' ' || v_matriz(i).num2 || ' ' || v_matriz(i).num3);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Matriz indicando las posiciones pares con 1 e impares con 0:');
    FOR i IN 1..elementos LOOP
        IF (MOD(v_matriz(i).num1,2) != 0) THEN
            v_matriz(i).num1 := 0;
        ELSE
            v_matriz(i).num1 := 1;
        END IF;
        IF (MOD(v_matriz(i).num2,2) != 0) THEN
            v_matriz(i).num2 := 0;
        ELSE
            v_matriz(i).num2 := 1;
        END IF;
        IF (MOD(v_matriz(i).num3,2) != 0) THEN
            v_matriz(i).num3 := 0;
        ELSE
            v_matriz(i).num3 := 1;
        END IF;
        DBMS_OUTPUT.PUT_LINE(v_matriz(i).num1 || ' ' || v_matriz(i).num2 || ' ' || v_matriz(i).num3);
    END LOOP;
END;

-- Solución al problema 14
DECLARE
    v_calif NUMBER := &calificacion;
BEGIN
    IF (v_calif >= 9 AND v_calif <= 10) THEN DBMS_OUTPUT.PUT_LINE('Nota: ' || v_calif || ' - SOBRESALIENTE');
    ELSIF (v_calif >= 7 AND v_calif < 9) THEN DBMS_OUTPUT.PUT_LINE('Nota: ' || v_calif || ' - NOTABLE');
    ELSIF (v_calif >= 6 AND v_calif < 7) THEN DBMS_OUTPUT.PUT_LINE('Nota: ' || v_calif || ' - BIEN');
    ELSIF (v_calif >= 5 AND v_calif < 6) THEN DBMS_OUTPUT.PUT_LINE('Nota: ' || v_calif || ' - SUFICIENTE');
    ELSIF (v_calif >= 3 AND v_calif < 5) THEN DBMS_OUTPUT.PUT_LINE('Nota: ' || v_calif || ' - INSUFICIENTE');
    ELSIF (v_calif >= 0 AND v_calif < 3) THEN DBMS_OUTPUT.PUT_LINE('Nota: ' || v_calif || ' - MUY INSUFICIENTE');
    ELSE DBMS_OUTPUT.PUT_LINE('NOTA INCORRECTA');
    END IF;
END;

-- Solución al problema 15
DECLARE
    v_menu NUMBER := &menu;    -- Menu: 1-Tangente, 2-Raíz cuadrada y 3-Potencia
    v_numero NUMBER := &numero;
    tang NUMBER;
    raiz NUMBER;
    potencia NUMBER;
BEGIN
    IF (v_menu = 1) THEN
        tang := TANH(v_numero);
        DBMS_OUTPUT.PUT_LINE('La tangente del número ' || v_numero || ' es: ' || tang);
    ELSIF (v_menu = 2) THEN
        raiz := SQRT(v_numero);
        DBMS_OUTPUT.PUT_LINE('La raiz cuadrada del número ' || v_numero || ' es: ' || raiz);
    ELSIF (v_menu = 3) THEN
        potencia := POWER(v_numero, 2);
        DBMS_OUTPUT.PUT_LINE('El número ' || v_numero || ' elevado a la potencia 2 es: ' || potencia);
    END IF;
END;

SET SERVEROUTPUT OFF