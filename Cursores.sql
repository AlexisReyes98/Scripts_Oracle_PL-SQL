SET SERVEROUTPUT ON

DECLARE
    v_fecha VARCHAR(10) := '';
BEGIN
    SELECT TO_CHAR(SYSDATE) INTO v_fecha FROM DUAL;
    DBMS_OUTPUT.PUT_LINE(' La fecha actual es: ' || v_fecha );
END;

CREATE TABLE libro2 (
    autor VARCHAR2(50),
    titulo VARCHAR2(50),
    editorial VARCHAR2(30),
    precio NUMBER(7,2),
    paginas NUMBER(4)
);

BEGIN
    INSERT INTO libro2 VALUES('Juan Lopez', 'PHP1', 'Mc Graw Hill', 532.98, 223);
    INSERT INTO libro2 VALUES('Juan Lopez', 'PHP2', 'Mc Graw Hill', 532.98, 254);
    INSERT INTO libro2 VALUES('Juan Lopez', 'PHP3', 'Mc Graw Hill', 485.98, 142);
    INSERT INTO libro2 VALUES('Ian Roward', 'Java', 'Pearson 1234', 123.58, 132);
    INSERT INTO libro2 VALUES('Mary Janes', 'Spiders', 'COMIC-CON', 314.15, 123);
    INSERT INTO libro2 VALUES('Jorge Segura', 'Freedom', 'PGR-PDI', 473.56, 134);
    INSERT INTO libro2 VALUES('Juana Arco', 'En llamas', 'Iglesias', 99.90, 166);
    INSERT INTO libro2 VALUES('Netz Romero', 'Calculo', 'Progreso', 180.00, 176);
END;

-- Cursores implícitos

DECLARE
    numReg NUMBER(5);
BEGIN
    SELECT count(*) INTO numReg FROM Libro2;
    DBMS_OUTPUT.PUT_LINE('Numero de Registros: ' || numReg);
END;

DECLARE
    v_autor VARCHAR2(50);
BEGIN
    SELECT autor INTO v_autor
    FROM libro2
    WHERE titulo LIKE 'Spiders';
    DBMS_OUTPUT.PUT_LINE('El autor de Spiders es: ' || v_autor);
END;

DECLARE
    v_autor VARCHAR2(50);
BEGIN
    SELECT autor INTO v_autor FROM libro2
    WHERE titulo = 'PHP4';
    DBMS_OUTPUT.PUT_LINE ('Autor : '|| v_autor);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE ('No existe el autor para el libro '|| 'PHP4');
END;

DECLARE
    v_titulo VARCHAR2(50);
    v_editorial libro2.editorial%TYPE;
BEGIN
    SELECT titulo, editorial INTO v_titulo, v_editorial FROM Libro2
    WHERE autor = 'Mary Janes';
    DBMS_OUTPUT.PUT_LINE('Titulo: ' || v_titulo);
    DBMS_OUTPUT.PUT_LINE('Editorial: ' || v_editorial);
END;

-- Cursores explícitos

DECLARE
    CURSOR c_libro IS
        SELECT autor, titulo, precio
        FROM libro2;
    v_autor VARCHAR2(50);
    v_titulo VARCHAR2(50);
    v_precio NUMBER(7,2);
BEGIN
    OPEN c_libro;
    LOOP
        FETCH c_libro INTO v_autor ,v_titulo ,v_precio;
        EXIT WHEN c_libro%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Autor: ' || v_autor || ' , Titulo: ' || v_titulo || ' , Precio: ' || v_precio);
    END LOOP;
    CLOSE c_libro;
END;

DECLARE
    CURSOR c_libro IS
        SELECT autor, titulo, precio
        FROM libro2;
    reg c_libro%ROWTYPE;
BEGIN
    OPEN c_libro;
    LOOP
        FETCH c_libro INTO reg;
        EXIT WHEN c_libro%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Autor: ' || reg.autor ||' , Titulo: ' || reg.titulo ||' , Precio: ' || reg.precio);
    END LOOP;
    CLOSE c_libro;
END;

DECLARE
    CURSOR c_libro (p_editorial VARCHAR2) IS
        SELECT autor, titulo, precio
        FROM libro2
    WHERE editorial = p_editorial;
    reg c_libro%ROWTYPE;
BEGIN
    OPEN c_libro('Mc Graw Hill');
    LOOP
        FETCH c_libro INTO reg;
        EXIT WHEN c_libro%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Autor: ' || reg.autor ||' , Titulo: ' || reg.titulo ||' , Precio: ' || reg.precio);
    END LOOP;
    CLOSE c_libro;
END;

-- Cursores y FOR ... IN

BEGIN
    FOR reg IN (SELECT *FROM Libro2)
LOOP
    DBMS_OUTPUT.PUT_LINE('Autor: ' || reg.autor ||' , Titulo: ' || reg.titulo);
END LOOP;
END;

CREATE TABLE libro_analisis (
    autor VARCHAR2(50),
    titulo VARCHAR2(50),
    precio NUMBER(7,2)
);

DECLARE
    CURSOR c_libro IS
        SELECT autor, titulo, precio
        FROM libro2
    WHERE precio > 200;
BEGIN
    FOR r_libro IN c_libro LOOP
        INSERT INTO libro_analisis
        VALUES(r_libro.autor, r_libro.titulo, r_libro.precio);
    END LOOP;
END;

SELECT *FROM libro_analisis;

TRUNCATE TABLE libro_analisis;

DECLARE
    CURSOR c_libro (p_precio IN libro2.precio%TYPE) IS
        SELECT autor, titulo, precio
        FROM libro2
        WHERE precio > p_precio;
BEGIN
    FOR r_libro IN c_libro (400) LOOP
        INSERT INTO libro_analisis
        VALUES(r_libro.autor, r_libro.titulo, r_libro.precio);
    END LOOP;
END;

SELECT *FROM libro_analisis;

DECLARE
    CURSOR c_liban IS
    SELECT titulo, precio
    FROM libro_analisis FOR UPDATE;
BEGIN
    FOR r_liban IN c_liban LOOP
        IF r_liban.precio > 500 THEN
            UPDATE libro_analisis
            SET precio = r_liban.precio - r_liban.precio * 0.20
            WHERE titulo = r_liban.titulo;
        END IF;
    END LOOP;
END;

SELECT *FROM libro_analisis;

COMMIT;
ROLLBACK;

-- Excepciones

DECLARE
    v_autor VARCHAR2(50);
BEGIN
    SELECT autor INTO v_autor
    FROM libro2
    WHERE titulo LIKE 'Spiders';
    DBMS_OUTPUT.PUT_LINE('El autor de Spiders es: ' || v_autor);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Spider '|| 'is not in the database');
END;

DECLARE
    v_uno NUMBER := 9.73;
    v_dos NUMBER := 0;
    v_res NUMBER;
BEGIN
    v_res := v_uno / v_dos;
    DBMS_OUTPUT.PUT_LINE('La división es: ' || v_res);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('División entre cero, cuidado!!');
    v_res := NULL;
END;

DECLARE
    err_num NUMBER;
    err_msg VARCHAR2(255);
    result NUMBER;
BEGIN
    SELECT 1/0 INTO result
    FROM DUAL;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;
    DBMS_OUTPUT.PUT_LINE('Error:' || TO_CHAR(err_num));
    DBMS_OUTPUT.PUT_LINE(err_msg);
END;

DECLARE
    err_num NUMBER;
    err_msg VARCHAR2(255);
    result NUMBER;
BEGIN
    INSERT INTO LIBRO
    VALUES('Vaswani Vikram','PHP',532.98,'Mc Graw Hill',532.98);
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;
    DBMS_OUTPUT.PUT_LINE('Error:' || TO_CHAR(err_num));
    DBMS_OUTPUT.PUT_LINE(err_msg);
END;

DECLARE
    VALOR_NEGATIVO EXCEPTION;
    valor NUMBER;
BEGIN
    valor := -1;
    IF valor < 0 THEN
        RAISE VALOR_NEGATIVO;
    END IF;
EXCEPTION
    WHEN VALOR_NEGATIVO THEN
    DBMS_OUTPUT.PUT_LINE('El valor no puede ser negativo');
END;

DECLARE
    e_exception1 EXCEPTION;
    e_exception2 EXCEPTION;
BEGIN
    -- bloque interno
    BEGIN
        RAISE e_exception1;
    EXCEPTION
        WHEN e_exception1 THEN
            RAISE e_exception2;
        WHEN e_exception2 THEN
            DBMS_OUTPUT.PUT_LINE ('Error en bloque interno');
    END;
EXCEPTION
    WHEN e_exception2 THEN
        DBMS_OUTPUT.PUT_LINE ('Error en el programa');
END;

SET SERVEROUTPUT OFF
