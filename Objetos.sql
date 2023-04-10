SET SERVEROUTPUT ON

-- Objetos en Oracle

CREATE or REPLACE TYPE address AS OBJECT (
    id NUMBER,
    street VARCHAR2(100),
    state VARCHAR2(3),
    zipcode VARCHAR2(11)
);

CREATE TABLE adress_table OF address;

INSERT INTO adress_table VALUES( address(2, '123 reforma', 'GRO', '09990'));
INSERT INTO adress_table VALUES( address(4, '321 medicos', 'COL', '06660'));
INSERT INTO adress_table VALUES( address(6, '231 hidalgo', 'OAX', '03330'));
INSERT INTO adress_table VALUES( address(8, '1125 vallejo', 'CMX', '09690'));

select * from adress_table;

select * from adress_table where id = 2;

update adress_table
set state = 'JAL'
where id = 2;

delete adress_table
where id = 6;

select * from adress_table;

-- Se crea una tabla que contenga como atributos a un objeto:

CREATE or REPLACE TYPE persona AS OBJECT (
    nombre VARCHAR2(30),
    edad NUMBER
);

CREATE TABLE contactos (
    contacto persona,
    fecha DATE
);

insert into contactos values (persona('juan', 33), TO_DATE('12/03/2006', 'DD/MM/YYYY'));
insert into contactos values (persona('paco', 22), TO_DATE('12/03/2016', 'DD/MM/YYYY'));
insert into contactos values (persona('susy', 11), TO_DATE('12/03/2026', 'DD/MM/YYYY'));

select * from contactos;    -- No sirve

select c.contacto.nombre, c.contacto.edad, c.fecha from contactos c;

-- Se crea un objeto que contenga otro objeto
CREATE or REPLACE TYPE addressType AS OBJECT (
    Street VARCHAR2(50),
    State VARCHAR2(25),
    Zip NUMBER
);

CREATE or REPLACE TYPE personType AS OBJECT (
    Name VARCHAR2(25),
    Address addressType
);

CREATE TABLE customer (
    IdCust NUMBER,
    Person personType
);

insert into customer values(1, personType('Mario', addressType('Oriente', 'CDMX', 15)));
insert into customer values(2, personType('Karen', addressType('Central', 'Tlax', 23)));

select * from customer; -- No sirve

select c.IdCust, c.Person.Name, c.Person.Address.Street,
    c.Person.Address.State, c.Person.Address.ZIP from customer c;

-- Para eliminar objetos
delete customer c
where c.Person.Address.ZIP = 15;

select c.IdCust, c.Person.Name, c.Person.Address.Street,
    c.Person.Address.State, c.Person.Address.ZIP from customer c;
    
DROP TABLE customer;

DROP TYPE personType;

DROP TYPE addressType;

-- Tabla de objetos
CREATE or REPLACE TYPE empType AS OBJECT (
    empno NUMBER,
    ename VARCHAR2(10),
    job VARCHAR2(10)
);

CREATE or REPLACE TYPE emp_tab_type AS TABLE OF empType;

CREATE TABLE dept_and_emp (
    deptno number(2) PRIMARY KEY,
    dname VARCHAR2(10),
    emps emp_tab_type
)
nested table emps store as emps_nt;

insert into dept_and_emp values(1, 'A12', emp_tab_type(empType(123, 'jorge', 'nominas'), empType(124, 'karla', 'contable'), empType(125, 'zulma', 'secretaria')));
insert into dept_and_emp values(2, 'B12', emp_tab_type(empType(123, 'jhonn', 'velador'), empType(124, 'zurch', 'limpieza'), empType(125, 'charl', 'portero')));
insert into dept_and_emp values(3, 'C12', emp_tab_type(empType(123, 'pepes', 'gerente'), empType(124, 'maria', 'director'), empType(125, 'josue', 'licenciado')));

select e1.deptno, e2.ename, e2.job from dept_and_emp e1, TABLE(e1.emps) e2;

-- Constructor
CREATE or REPLACE TYPE address2 AS OBJECT (
    id NUMBER,
    street VARCHAR2(100),
    state VARCHAR2(3),
    zipcode VARCHAR2(11),
    CONSTRUCTOR FUNCTION address2(c_id NUMBER, c_street VARCHAR2, c_state VARCHAR2)
    RETURN SELF AS RESULT
);

CREATE OR REPLACE TYPE BODY address2 AS
    CONSTRUCTOR FUNCTION address2(c_id NUMBER, c_street VARCHAR2, c_state VARCHAR2)
    RETURN SELF AS RESULT
    IS
    BEGIN
        SELF.id:=c_id;
        SELF.street:=c_street;
        SELF.state:=c_state;
        SELF.zipcode:='1516';
        RETURN;
    END;
END;

CREATE TABLE adress_table2 OF address2;

insert into adress_table2 values( address2(3, '222 balderas', 'CMX'));
insert into adress_table2 values( address2(2, '123 guerrero', 'SIN', '09990'));

select * from adress_table2;

-- Métodos
CREATE TABLE reg_operative (
    state VARCHAR2(3),
    region VARCHAR(10)
);

insert into reg_operative values ('GRO', 'centro');
insert into reg_operative values ('COL', 'occidente');
insert into reg_operative values ('OAX', 'sureste');
insert into reg_operative values ('CMX', 'centro');
insert into reg_operative values ('DUR', 'noreste');
insert into reg_operative values ('SIN', 'noroeste');

CREATE or REPLACE TYPE address3 AS OBJECT (
    id NUMBER,
    street VARCHAR2(100),
    state VARCHAR2(3),
    zipcode VARCHAR2(11),
    CONSTRUCTOR FUNCTION address3(c_id NUMBER, c_street VARCHAR2, c_state VARCHAR2)
    RETURN SELF AS RESULT,
    MEMBER FUNCTION regOperMx RETURN VARCHAR2,
    MEMBER PROCEDURE display_id
);

CREATE OR REPLACE TYPE BODY address3 AS
    CONSTRUCTOR FUNCTION address3(c_id NUMBER, c_street VARCHAR2, c_state VARCHAR2)
    RETURN SELF AS RESULT IS
    BEGIN
        SELF.id := c_id;
        SELF.street := c_street;
        SELF.state := c_state;
        SELF.zipcode := '1516';
        RETURN;
    END;
    MEMBER FUNCTION regOperMx RETURN VARCHAR2 IS
        c_region VARCHAR(10);
    BEGIN
        select region into c_region from reg_operative where state = SELF.state;
        RETURN c_region;
    END;
    MEMBER PROCEDURE display_id IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' Id: ' || id);
    END;
END;

CREATE TABLE adress_table3 OF address3;
insert into adress_table3 values( address3(3, '222 balderas', 'CMX'));
insert into adress_table3 values( address3(2, '123 guerrero', 'SIN', '09990'));

select ad.state, ad.regOperMx() from adress_table3 ad;

DECLARE
    ad address3;
BEGIN
    ad := address3(2, '123 guerrero', 'SIN', '09990');
    ad.display_id;
END;

-- Números complejpos
CREATE OR REPLACE TYPE Complejo AS OBJECT (
    parte_r REAL,
    parte_i REAL,
    MEMBER FUNCTION suma (x Complejo) RETURN Complejo,
    MEMBER FUNCTION resta (x Complejo) RETURN Complejo
);

CREATE OR REPLACE TYPE BODY Complejo AS
    MEMBER FUNCTION suma (x Complejo) RETURN Complejo IS
    BEGIN
        RETURN Complejo(parte_r + x.parte_r, parte_i + x.parte_i);
    END suma;
    MEMBER FUNCTION resta (x Complejo) RETURN Complejo IS
    BEGIN
        RETURN Complejo(parte_r - x.parte_r, parte_i - x.parte_i);
    END resta;
END;

CREATE TABLE operComp (
    oper NUMBER,
    comp Complejo
);

insert into operComp values(1, Complejo(4, 6));
insert into operComp values(2, Complejo(5, 7));

select oc.oper, oc.comp.parte_r, oc.comp.parte_i from operComp oc;

DECLARE
    comp Complejo;
BEGIN
    select oc.comp.suma(Complejo(2, 3)) INTO comp from operComp oc
        where oc.oper = 1;
    DBMS_OUTPUT.PUT_LINE(' Resultado imaginario: ' || comp.parte_r);
    DBMS_OUTPUT.PUT_LINE(' Resultado real: ' || comp.parte_i);
    DBMS_OUTPUT.PUT_LINE(' ------------------------------------ ');
    select oc.comp.resta(Complejo(2, 3)) INTO comp from operComp oc
        where oc.oper = 2;
    DBMS_OUTPUT.PUT_LINE(' Resultado imaginario: ' || comp.parte_r);
    DBMS_OUTPUT.PUT_LINE(' Resultado real: ' || comp.parte_i);
END;

SET SERVEROUTPUT OFF