SET SERVEROUTPUT ON

-- Particiones
-- https://oraxedatabase.blogspot.com/2019/01/crear-y-administrar-espacios-de.html

-- Particionado por List
CREATE TABLE list_part (
    deptno NUMBER(10),
    deptname VARCHAR2(20),
    quarterly_sales NUMBER(10,2),
    state VARCHAR2(2))
PARTITION BY LIST (state)(
    PARTITION q1_northwest VALUES ('OR', 'WA'),
    PARTITION q1_southwest VALUES ('AZ', 'CA', 'NM'),
    PARTITION q1_northeast VALUES ('NY', 'VT', 'NJ'),
    PARTITION q1_southeast VALUES ('FL', 'GA'),
    PARTITION q1_northcent VALUES ('MN', 'WI'),
    PARTITION q1_southcent VALUES ('OK', 'TX')
);

-- Se revisan sus características
SELECT table_name, partition_name, high_value, tablespace_name, partition_position
FROM user_tab_partitions
WHERE table_name = 'LIST_PART';

INSERT INTO list_part VALUES (10, 'A', 3000, 'OR');
INSERT INTO list_part VALUES (20, 'B', 1000, 'AZ');
INSERT INTO list_part VALUES (10, 'A', 7000, 'WA');
INSERT INTO list_part VALUES (20, 'B', 2500, 'WA');
INSERT INTO list_part VALUES (10, 'A', 1300, 'AZ');
INSERT INTO list_part VALUES (20, 'B', 6000, 'CA');
COMMIT;

SELECT * FROM list_part;

SELECT * FROM list_part PARTITION(q1_northwest);

SELECT * FROM list_part PARTITION(q1_southwest);

-- Truncar una partición
ALTER TABLE list_part TRUNCATE PARTITION q1_northwest;

SELECT * FROM list_part PARTITION(q1_northwest);

-- Renombrar una partición
ALTER TABLE list_part RENAME PARTITION q1_northwest TO q1_noroeste;

SELECT table_name, partition_name, high_value, tablespace_name, partition_position
FROM user_tab_partitions
WHERE table_name = 'LIST_PART';

-- Eliminar una partición
ALTER TABLE list_part DROP PARTITION q1_noroeste;

SELECT table_name, partition_name, high_value, tablespace_name, partition_position
FROM user_tab_partitions
WHERE table_name = 'LIST_PART';

-- Agregar una partición
ALTER TABLE list_part ADD PARTITION q1_CENTER VALUES ('KA', 'NE', 'CO', 'MI');

SELECT table_name, partition_name, high_value, tablespace_name, partition_position
FROM user_tab_partitions
WHERE table_name = 'LIST_PART';

-- Fusionar particiones
ALTER TABLE list_part MERGE PARTITIONS q1_NORTHEAST, q1_SOUTHEAST INTO PARTITION q1_EAST;

CREATE BIGFILE TABLESPACE part1
DATAFILE 'part_f1.dat'
SIZE 20M
AUTOEXTEND ON;

CREATE TABLE range_part (
    prof_history_id NUMBER(10),
    person_id NUMBER(10) NOT NULL,
    organization_id NUMBER(10) NOT NULL,
    record_date DATE NOT NULL)
PARTITION BY RANGE (record_date)
(
    PARTITION yr0 VALUES LESS THAN (TO_DATE('01-JAN-2007','DD-MON-YYYY'))
    TABLESPACE part1,
    PARTITION yr7 VALUES LESS THAN (TO_DATE('01-JAN-2008','DD-MON-YYYY'))
    TABLESPACE part2,
    PARTITION yr8 VALUES LESS THAN (TO_DATE('01-JAN-2009','DD-MON-YYYY'))
    TABLESPACE part3,
    PARTITION yr9 VALUES LESS THAN (MAXVALUE)
    TABLESPACE part4
);

SELECT table_name, tablespace_name, partitioned
FROM user_tables;

-- Se revisan sus características.
SELECT table_name, partition_name, high_value
FROM user_tab_partitions
WHERE table_name = 'RANGE_PART';

INSERT INTO range_part
VALUES (1, 1, 1, to_date('2006/07/09', 'yyyy/mm/dd'));
INSERT INTO range_part
VALUES(2, 2, 2, to_date('2007/07/09', 'yyyy/mm/dd'));
INSERT INTO range_part
VALUES (3, 3, 3, to_date('2008/07/09', 'yyyy/mm/dd'));
INSERT INTO range_part
VALUES (4, 4, 4, to_date('2008/09/09', 'yyyy/mm/dd'));
INSERT INTO range_part
VALUES (5, 5, 5, SYSDATE);

-- Se consulta la tabla.
SELECT * FROM range_part;

-- Se consulta por partición.
SELECT * FROM range_part PARTITION(yr6);

SELECT * FROM range_part PARTITION(yr7);

SELECT * FROM range_part PARTITION(yr8);

SELECT * FROM range_part PARTITION(yr0);

CREATE TABLE students (
    student_id NUMBER(6),
    student_fn VARCHAR2(25),
    student_ln VARCHAR2(25),
    PRIMARY KEY (student_id))
PARTITION BY RANGE (student_ln)
(
    PARTITION student_ae VALUES LESS THAN ('F%') TABLESPACE part1,
    PARTITION student_fl VALUES LESS THAN ('M%') TABLESPACE part2,
    PARTITION student_mr VALUES LESS THAN ('S%') TABLESPACE part3,
    PARTITION student_sz VALUES LESS THAN (MAXVALUE) TABLESPACE part4
);

INSERT INTO students VALUES (1, 'Juan', 'Gomez');
INSERT INTO students VALUES (2, 'Paco', 'Bayes');
INSERT INTO students VALUES (3, 'Maya', 'Torres');
INSERT INTO students VALUES (4, 'Katy', 'Moran');
INSERT INTO students VALUES (5, 'Pepe', 'Romeo');
INSERT INTO students VALUES (6, 'Lucy', 'Correa');
INSERT INTO students VALUES (7, 'Cass', 'Zetina');
INSERT INTO students VALUES (8, 'Beto', 'Lopez');
INSERT INTO students VALUES (9, 'Paca', 'Suarez');

-- Se consulta por partición.
SELECT * FROM students PARTITION(student_ae);

SELECT * FROM students PARTITION(student_fl);

SELECT * FROM students PARTITION(student_mr);

SELECT * FROM students PARTITION(student_sz);

CREATE TABLE lectura (
    letras_no NUMBER,
    nombre_lt VARCHAR2(25) NOT NULL,
    comentarios VARCHAR2(500))
PARTITION BY HASH (nombre_lt)
(
    PARTITION invoices_q1,
    PARTITION invoices_q2,
    PARTITION invoices_q3
);

INSERT INTO lectura VALUES (43, 'Politica nocturna', 'Comentario de Karl en TV');
INSERT INTO lectura VALUES (24, 'Comediante teatro', 'Apertura al drama social');
INSERT INTO lectura VALUES (77, 'Cartas en la vida', 'Libro coleccionable azul');
INSERT INTO lectura VALUES (13, 'Perdidos en marea', 'Barcos en altamar marino');
INSERT INTO lectura VALUES (68, 'Centro social 123', 'Gente economica activada');
INSERT INTO lectura VALUES (13, 'Soldado en marcha', 'Militancias en el zocalo');
INSERT INTO lectura VALUES (68, 'Planeta orbitando', 'Cambios estacionales 123');

SELECT * FROM lectura PARTITION(invoices_q1);

SELECT * FROM lectura PARTITION(invoices_q2);

SELECT * FROM lectura PARTITION(invoices_q3);

CREATE TABLE ord (
    ord_id VARCHAR(7),
    ord_day NUMBER(2),
    ord_month NUMBER(2),
    ord_year NUMBER(4)
)
PARTITION BY RANGE(ord_year)
SUBPARTITION BY HASH(ord_id)(
    PARTITION q1 VALUES LESS THAN(2001) (
        SUBPARTITION q1_h1,
        SUBPARTITION q1_h2
    ),
    PARTITION q2 VALUES LESS THAN(2002) (
        SUBPARTITION q2_h3,
        SUBPARTITION q2_h4
    ),
    PARTITION q3 VALUES LESS THAN(2003) (
        SUBPARTITION q3_h5,
        SUBPARTITION q3_h6
    )
)

INSERT INTO ord VALUES ('FD6G3Y', 3, 10, 2001);
INSERT INTO ord VALUES ('JF53DS', 12, 2, 2000);
INSERT INTO ord VALUES ('NCS346', 24, 5, 2001);
INSERT INTO ord VALUES ('32ASDT', 30, 9, 2002);
INSERT INTO ord VALUES ('4DQ75G', 2, 11, 2002);
INSERT INTO ord VALUES ('GY63F4', 9, 12, 2001);
INSERT INTO ord VALUES ('ML52FD', 13, 8, 2000);
INSERT INTO ord VALUES ('ZAW4E4', 19, 1, 2000);
INSERT INTO ord VALUES ('532GD4', 7, 10, 2001);
INSERT INTO ord VALUES ('4FDS53', 21, 7, 2002);
INSERT INTO ord VALUES ('GD32D1', 21, 7, 2002);

SELECT * FROM ord PARTITION(q1);

SELECT * FROM ord SUBPARTITION(q1_h1);

SELECT * FROM ord SUBPARTITION(q1_h2);

SELECT * FROM ord PARTITION(q2);

SELECT * FROM ord SUBPARTITION(q2_h3);

SELECT * FROM ord SUBPARTITION(q2_h4);

SELECT * FROM ord PARTITION(q3);

SELECT * FROM ord SUBPARTITION(q3_h5);

SELECT * FROM ord SUBPARTITION(q3_h6);

SET SERVEROUTPUT OFF
