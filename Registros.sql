SET SERVEROUTPUT ON

-- Registros

DECLARE
    TYPE books IS RECORD(
    title varchar(50),
    author varchar(50),
    subject varchar(100),
    book_id number);
    book1 books;
    book2 books;
BEGIN
    -- Book 1 specification
    book1.title := 'C Programming';
    book1.author := 'Nuha Ali ';
    book1.subject := 'C Programming Tutorial';
    book1.book_id := 6495407;
    -- Book 2 specification
    book2.title := 'Telecom Billing';
    book2.author := 'Zara Ali';
    book2.subject := 'Telecom Billing Tutorial';
    book2.book_id := 6495700;
    -- Print book 1 record
    DBMS_OUTPUT.PUT_LINE('Book 1 title : '|| book1.title);
    DBMS_OUTPUT.PUT_LINE('Book 1 author : '|| book1.author);
    DBMS_OUTPUT.PUT_LINE('Book 1 subject : '|| book1.subject);
    DBMS_OUTPUT.PUT_LINE('Book 1 book_id : ' || book1.book_id);
    -- Print book 2 record
    DBMS_OUTPUT.PUT_LINE('Book 2 title : '|| book2.title);
    DBMS_OUTPUT.PUT_LINE('Book 2 author : '|| book2.author);
    DBMS_OUTPUT.PUT_LINE('Book 2 subject : '|| book2.subject);
    DBMS_OUTPUT.PUT_LINE('Book 2 book_id : '|| book2.book_id);
END;

DECLARE
    type books is record(
    title varchar(50),
    author varchar(50),
    subject varchar(100),
    book_id number);
    book1 books;
    book2 books;
PROCEDURE printbook (book books) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Book title : ' || book.title);
    DBMS_OUTPUT.PUT_LINE('Book author : ' || book.author);
    DBMS_OUTPUT.PUT_LINE( 'Book subject : ' || book.subject);
    DBMS_OUTPUT.PUT_LINE( 'Book book_id : ' || book.book_id);
END;
BEGIN
    -- Book 1 specification
    book1.title := 'C Programming';
    book1.author := 'Nuha Ali ';
    book1.subject := 'C Programming Tutorial';
    book1.book_id := 6495407;
    -- Book 2 specification
    book2.title := 'Telecom Billing';
    book2.author := 'Zara Ali';
    book2.subject := 'Telecom Billing Tutorial';
    book2.book_id := 6495700;
    -- Use procedure to print book info
    printbook(book1);
    printbook(book2);
END;

DECLARE
    type complejo is record(
    real float,
    imaginario float);
    complejo1 complejo;
    complejo2 complejo;
    res complejo;
FUNCTION sumacomplejos (c1 complejo, c2 complejo)
RETURN complejo
IS
    resultado complejo;
BEGIN
    resultado.real := c1.real + c2.real;
    resultado.imaginario:= c1.imaginario + c2.imaginario;
    RETURN resultado;
END;
BEGIN
    complejo1.real := 10;
    complejo1.imaginario := 5;
    complejo2.real := 30;
    complejo2.imaginario := 15;
    res := sumacomplejos(complejo1, complejo2);
    DBMS_OUTPUT.PUT_LINE ('La suma real es: ' || res.real);
    DBMS_OUTPUT.PUT_LINE ('La suma imaginaria es: ' || res.imaginario);
END;

DECLARE
    TYPE PAIS IS RECORD(
    CO_PAIS NUMBER ,
    DESCRIPCION VARCHAR2(50),
    CONTINENTE VARCHAR2(20));
    miPAIS PAIS;
BEGIN
    miPAIS.CO_PAIS := 27;
    miPAIS.DESCRIPCION := 'ITALIA';
    miPAIS.CONTINENTE := 'EUROPA';
    DBMS_OUTPUT.PUT_LINE('El codigo es: ' || miPAIS.CO_PAIS);
    DBMS_OUTPUT.PUT_LINE('El pais es: ' || miPAIS.DESCRIPCION);
    DBMS_OUTPUT.PUT_LINE('Su continente es: ' || miPAIS.CONTINENTE);
END;

-- Registros anidados
DECLARE
    TYPE PAIS IS RECORD(
        CO_PAIS NUMBER,
        DESCRIPCION VARCHAR2(50),
        CONTINENTE VARCHAR2(20));
    TYPE MONEDA IS RECORD(
        DESCRIPCION VARCHAR2(50),
        PAIS_MONEDA PAIS);
    miPAIS PAIS;
    miMONEDA MONEDA;
BEGIN
    miPAIS.CO_PAIS := 27;
    miPAIS.DESCRIPCION := 'ITALIA';
    miPAIS.CONTINENTE := 'EUROPA';
    miMONEDA.DESCRIPCION := 'LIRA';
    miMONEDA.PAIS_MONEDA := miPAIS;
    DBMS_OUTPUT.PUT_LINE('Su moneda es: ' || miMONEDA.DESCRIPCION);
    DBMS_OUTPUT.PUT_LINE('El codigo es: ' || miMONEDA.PAIS_MONEDA.CO_PAIS);
    DBMS_OUTPUT.PUT_LINE('El pais es: ' || miMONEDA.PAIS_MONEDA.DESCRIPCION);
    DBMS_OUTPUT.PUT_LINE('Su continente es: ' || miMONEDA.PAIS_MONEDA.CONTINENTE);
END;

SET SERVEROUTPUT OFF