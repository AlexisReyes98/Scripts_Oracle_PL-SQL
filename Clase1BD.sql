CREATE TABLE LIBRO
(
    AUTOR VARCHAR2(50),
    TITULO VARCHAR2(50),
    EDITORIAL VARCHAR2(50),
    PRECIO NUMBER(7,2),
    PAGINAS NUMBER(4)
);

INSERT INTO LIBRO VALUES('Vaswani Vikram','PHP','Mc Graw Hill',532.98,254);

INSERT INTO LIBRO VALUES('Sawyer Mcfarland','Javascript','Anaya',892,419);

INSERT INTO LIBRO VALUES('Hernandez Figueroa Jose','Fundamentos de Estructura de Datos','Paraninfo',211,263);

INSERT INTO LIBRO VALUES('Drozdek Adam','Estructura de Datos en Java','Thomson',205,383);

INSERT INTO LIBRO VALUES('Parsons David','Desarrollo de Aplicaciones WEB','Anaya',1021,623);

INSERT INTO LIBRO VALUES('Jean Marie Chauvet','Corba ActiveX','Prentice Hall',326,421);

INSERT INTO LIBRO VALUES('Sagan Carl','Mundo y sus Demonios','Planeta',278,374);

INSERT INTO LIBRO VALUES('Sagan Carl','Un punto azul palido','Planeta',479,412);

INSERT INTO LIBRO VALUES('Sagan Carl','Dragones del Eden','Critica',195,231);

INSERT INTO LIBRO VALUES('Sagan Carl','Cosmos','Ediciones',159,256);

INSERT INTO LIBRO VALUES('Brust Andrew','Programacion SQL','Mc Graw Hill',653,423);

INSERT INTO LIBRO VALUES('Arce Anguiano','Programacion en FLASH','Alfaomega',223,273);

INSERT INTO LIBRO VALUES('Wall Kurt','Programacion en Linux','Pearson',523,483);

INSERT INTO LIBRO VALUES('Abel Peter','Lenguaje Ensamblador','Alfaomega',388,295);

INSERT INTO LIBRO VALUES('Cornell Gary','Core Java','Prentice Hall', 487,452);

INSERT INTO LIBRO VALUES('Pratt Phlip J.','SQL', 'Anaya',412,354);

INSERT INTO LIBRO VALUES('Brust Andrey','Programacion Avanzada con SQL','Mc Graw Hill', 892,623);

INSERT INTO LIBRO VALUES('Brust Andrew', 'SQL Basico', 'Prentice Hall',402,485);

INSERT INTO LIBRO VALUES('Groff James','Manual SQL','Mc Graw Hill',255,196);

SELECT *FROM libro;

SELECT autor, titulo FROM libro;

SELECT DISTINCT autor FROM libro;

SELECT *FROM libro WHERE autor = 'Sagan Carl';

SELECT *FROM libro WHERE precio > 300;

SELECT *FROM libro WHERE precio BETWEEN 300 AND 500;

SELECT *FROM libro WHERE precio IN(412,388);

SELECT *FROM libro WHERE autor LIKE 'S%';

SELECT *FROM libro WHERE autor LIKE '_a%';

SELECT *FROM libro WHERE autor NOT LIKE 'S%';

SELECT *FROM libro WHERE precio > 500 AND editorial = 'Mc Graw Hill';

SELECT *FROM libro WHERE precio > 500 AND editorial = 'Mc Graw Hill' OR editorial = 'Pearson';

SELECT *FROM libro WHERE precio > 500 AND (editorial = 'Mc Graw Hill' OR editorial = 'Pearson');

SELECT *FROM libro WHERE precio > 500 OR editorial = 'Pearson';

SELECT *FROM libro WHERE NOT precio > 500;

SELECT *FROM libro ORDER BY precio;

SELECT *FROM libro ORDER BY precio DESC;

SELECT *FROM libro ORDER BY 5 DESC;

SELECT autor "A", titulo "T", editorial "E" FROM libro ORDER BY "A";

SELECT DISTINCT editorial FROM libro ORDER BY editorial;

SELECT COUNT(*) FROM libro;

SELECT COUNT (titulo), COUNT (editorial) FROM libro;

SELECT SUM(precio) FROM libro;

SELECT AVG(precio) FROM libro;

SELECT NVL(precio,0) FROM libro;

SELECT AVG(precio), AVG(NVL(precio,0)) FROM libro;

SELECT MIN(precio), MAX(precio) FROM libro;

SELECT MIN(precio) AS "Precio Minimo", MAX(precio) AS "Precio Maximo" FROM libro;

SELECT AVG(CASE WHEN editorial = 'Planeta' THEN precio*1.5
    WHEN editorial = 'Critica' THEN precio*2.0
    ELSE precio
    END) AS AVG
    FROM libro;

SELECT editorial FROM libro GROUP BY editorial;

SELECT editorial, count(*) FROM libro GROUP BY editorial;

SELECT editorial, count(*),
    SUM(precio) AS sum, AVG(precio) AS avg,
    MIN(precio) AS min, MAX(precio) AS max
FROM libro GROUP BY editorial;

SELECT editorial, autor, count(*) FROM libro GROUP BY editorial, autor;

SELECT editorial, autor, count(*) FROM libro
GROUP BY editorial, autor ORDER BY editorial, autor;

SELECT editorial, autor, count(*) FROM libro
GROUP BY editorial, autor HAVING count(*) > 1;

CREATE TABLE tablaUno
(
    col1 NUMBER(10),
    col2 NUMBER(4,2),
    col3 VARCHAR2(5),
    col4 VARCHAR2(20),
    col5 NUMBER
);

INSERT INTO tablaUno VALUES(10,12.10,'aaa','bbb',12345);

CREATE TABLE tablaDos
(
    col1 NUMBER(10) PRIMARY KEY,
    col2 NUMBER(4,2) NOT NULL,
    col3 VARCHAR2(5) UNIQUE,
    col4 VARCHAR2(20),
    col5 NUMBER CHECK(col5<100)
);

INSERT INTO tablaDos VALUES(123,10.10,'aaa','bbb',10);

DROP TABLE tablaDos;

CREATE TABLE tablaTres
(
    col1 VARCHAR2(20) PRIMARY KEY
);

CREATE TABLE tablaDos
(
    col1 NUMBER(10) PRIMARY KEY,
    col2 NUMBER(4,2) NOT NULL,
    col3 VARCHAR2(5) UNIQUE,
    col4 VARCHAR2(20) REFERENCES tablaTres(col1),
    col5 NUMBER CHECK(col5<100)
);

SELECT autor, titulo, editorial FROM libro
WHERE precio < (SELECT AVG(PRECIO) FROM LIBRO);

SELECT *FROM libro
WHERE editorial IN(SELECT editorial FROM libro WHERE titulo LIKE '%SQL%')
AND titulo LIKE '%Java%';

SELECT a.titulo, a.editorial, a.autor, a.precio, b.precProm
FROM libro a, (SELECT autor, AVG(precio) precProm
FROM libro GROUP BY autor) b
WHERE a.autor = b.autor AND a.precio > b.precProm;
