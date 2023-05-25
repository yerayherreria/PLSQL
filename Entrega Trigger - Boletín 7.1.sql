--Crea la siguiente tabla:
CREATE TABLE empleados2
(dni VARCHAR2(9) PRIMARY KEY,
nomemp VARCHAR2(50),
jefe VARCHAR2(9),
departamento NUMBER,
salario NUMBER(9,2) DEFAULT 1000,
usuario VARCHAR2(50),
fecha DATE,
CONSTRAINT FK_JEFE FOREIGN KEY (jefe) REFERENCES empleados2 (dni) );
--Ejercicio 1
--Crear un trigger sobre la tabla EMPLEADOS para que no se permita que un empleado
--sea jefe de más de cinco empleados.
CREATE OR REPLACE TRIGGER DUMMY.EJER1
	BEFORE INSERT ON EMPLEADOS2
	FOR EACH ROW 
DECLARE 
	JEFEC NUMBER;
BEGIN 
	SELECT COUNT(E.DNI) INTO JEFEC
	FROM EMPLEADOS2 e 
	WHERE E.JEFE LIKE :NEW.JEFE;
	
	IF JEFEC>=5 THEN
		RAISE_APPLICATION_ERROR(-20002,'ERROR. EL JEFE TIENE MÁS DE CINCO EMPLEADOS');
	END IF;
END;
--PRUEBA
INSERT INTO EMPLEADOS2 
VALUES('28984753S','YERAY',NULL,1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));

INSERT INTO EMPLEADOS2 
VALUES('28918475A','M','28984753S',1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));
INSERT INTO EMPLEADOS2 
VALUES('28198473B','A','28984753S',1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));
INSERT INTO EMPLEADOS2 
VALUES('28198453C','N','28984753S',1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));
INSERT INTO EMPLEADOS2 
VALUES('28194753D','O','28984753S',1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));
INSERT INTO EMPLEADOS2 
VALUES('28184753F','A','28984753S',1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));

--Ejercicio 2
--Crear un trigger para impedir que se aumente el salario de un empleado en más de un
--20%.
CREATE OR REPLACE 
TRIGGER EJER2
	AFTER UPDATE ON EMPLEADOS2 
	FOR EACH ROW
BEGIN 
	IF :NEW.SALARIO > :OLD.SALARIO*1.2 THEN 
		RAISE_APPLICATION_ERROR(-20003,'ERROR. EL SALARIO NO PUEDE SER MAYOR AL 20%.');
	END IF;
END;
--PRUEBA
UPDATE EMPLEADOS2 
SET SALARIO = 3000
WHERE DNI='28918475A';

--Ejercicio 3
--Crear una tabla empleados_baja con la siguiente estructura:
CREATE TABLE empleados_baja
( dni VARCHAR2(9) PRIMARY KEY,
nomemp VARCHAR2 (50),
jefe VARCHAR2(9),
departamento NUMBER,
salario NUMBER(9,2) DEFAULT 1000,
usuario VARCHAR2(50),
fecha DATE );
--Crear un trigger que inserte una fila en la tabla empleados_baja cuando se borre una fila
--en la tabla empleados. Los datos que se insertan son los del empleado que se da de baja
--en la tabla empleados, salvo en las columnas usuario y fecha se grabarán las variables
--del sistema USER y SYSDATE que almacenan el usuario y fecha actual
CREATE OR REPLACE TRIGGER EJER3
	AFTER DELETE ON EMPLEADOS2
	FOR EACH ROW 
BEGIN 
	INSERT INTO EMPLEADOS_BAJA 
	VALUES(:OLD.DNI,:OLD.NOMEMP,:OLD.JEFE,:OLD.DEPARTAMENTO,:OLD.SALARIO,USER,SYSDATE);
END;
--PRUEBA
DELETE 
FROM EMPLEADOS2 e 
WHERE E.DNI = '28184753F';
SELECT * FROM EMPLEADOS_BAJA eb;

--Ejercicio 4
--Crear un trigger para impedir que, al insertar un empleado, el empleado y su jefe puedan
--pertenecer a departamentos distintos. Es decir, el jefe y el empleado deben pertenecer al
--mismo departamento.
CREATE OR REPLACE TRIGGER EJER4
	BEFORE INSERT ON EMPLEADOS2
	FOR EACH ROW
DECLARE 
	COD_DEPT NUMBER;
BEGIN
	SELECT E.DEPARTAMENTO INTO COD_DEPT
	FROM EMPLEADOS2 e 
	WHERE E.DNI LIKE :NEW.JEFE;
	IF COD_DEPT!=:NEW.DEPARTAMENTO THEN
		RAISE_APPLICATION_ERROR(-20004,'EL EMPLEADO Y EL JEFE NO PUEDE PERTENECER A DISTINTO DEPARTAMENTO.');
	END IF;
END;
--PRUEBA
INSERT INTO EMPLEADOS2 
VALUES('28984753S','YERAY',NULL,1,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));

INSERT INTO EMPLEADOS2 
VALUES('28918475A','M','28984753S',2,123,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));
	
--Ejercicio 5
--Crear un trigger para impedir que, al insertar un empleado, la suma de los salarios de los
--empleados pertenecientes al departamento del empleado insertado supere los 10.000
--euros.
CREATE OR REPLACE TRIGGER EJER5
	BEFORE INSERT ON EMPLEADOS2
	FOR EACH ROW 
DECLARE 
	SUMA_SAL NUMBER;
BEGIN
	SELECT SUM(E.SALARIO) INTO SUMA_SAL
	FROM EMPLEADOS2 e 
	WHERE E.DEPARTAMENTO = :NEW.DEPARTAMENTO;

	SUMA_SAL:=SUMA_SAL+:NEW.SALARIO;
	IF (SUMA_SAL>10000) THEN
		RAISE_APPLICATION_ERROR(-20005,'SALARIO TOTAL SUPERIOR A 10000.');	
	END IF;
END;
--PRUEBA
INSERT INTO EMPLEADOS2 
VALUES('28918475A','M',NULL,1,10000,'HERR',TO_DATE('12/12/1999','DD/MM/YYYY'));

--Ejercicio 6
--Crea la tabla:
CREATE TABLE controlCambios(
usuario varchar2(30),
fecha date,
tipooperacion varchar2(30),
datoanterior varchar2(30),
datonuevo varchar2(30)
);
--Creamos un trigger que se active cuando modificamos algún campo de "empleados" y
--almacene en "controlCambios" el nombre del usuario que realiza la actualización, la
--fecha, el tipo de operación que se realiza, el dato que se cambia y el nuevo valor.
CREATE OR REPLACE TRIGGER EJER6
	BEFORE UPDATE ON EMPLEADOS2
	FOR EACH ROW
DECLARE 
	DATO_OLD VARCHAR2(50);
	DATO_NEW VARCHAR2(50);
BEGIN
	IF UPDATING('DNI') THEN
		DATO_OLD:=TO_CHAR(:OLD.DNI);
		DATO_NEW:=TO_CHAR(:NEW.DNI);
		
	ELSIF UPDATING('NOMEMP') THEN
		DATO_OLD:=TO_CHAR(:OLD.NOMEMP);
		DATO_NEW:=TO_CHAR(:NEW.NOMEMP);
		
	ELSIF UPDATING('JEFE') THEN	
		DATO_OLD:=TO_CHAR(:OLD.JEFE);
		DATO_NEW:=TO_CHAR(:NEW.JEFE);
		
	ELSIF UPDATING('DEPARTAMENTO') THEN	
		DATO_OLD:=TO_CHAR(:OLD.DEPARTAMENTO);
		DATO_NEW:=TO_CHAR(:NEW.DEPARTAMENTO);
		
	ELSIF UPDATING('SALARIO') THEN	
		DATO_OLD:=TO_CHAR(:OLD.SALARIO);
		DATO_NEW:=TO_CHAR(:NEW.SALARIO);
		
	ELSIF UPDATING('USUARIO') THEN	
		DATO_OLD:=TO_CHAR(:OLD.USUARIO);
		DATO_NEW:=TO_CHAR(:NEW.USUARIO);
		
	ELSIF UPDATING('FECHA') THEN	
		DATO_OLD:=TO_CHAR(:OLD.FECHA);
		DATO_NEW:=TO_CHAR(:NEW.FECHA);
	END IF;
	INSERT INTO controlCambios 
	VALUES (TO_CHAR(USER),SYSDATE,'MODIFICACION',DATO_OLD,DATO_NEW);
END;
--PRUEBA
UPDATE EMPLEADOS2 
SET SALARIO = 100
WHERE DNI='28198453C';

SELECT * FROM CONTROLCAMBIOS c;

--Ejercicio 7
--Creamos otro trigger que se active cuando ingresamos un nuevo registro en "empleados",
--debe almacenar en "controlCambios" el nombre del usuario que realiza el ingreso, la
--fecha, el tipo de operación que se realiza , "null" en "datoanterior" (porque se dispara con
--una inserción) y en "datonuevo" el valor del nuevo dato.
CREATE OR REPLACE TRIGGER EJER7
	AFTER INSERT ON EMPLEADOS2
	FOR EACH ROW
BEGIN 
   INSERT INTO CONTROLCAMBIOS c 
   VALUES(TO_CHAR(USER), SYSDATE, 'INSERT ', NULL, :NEW.DNI || :NEW.nomemp || :NEW.jefe || :NEW.departamento || :NEW.salario || :NEW.usuario || :NEW.FECHA );
END;
--PRUEBA
UPDATE EMPLEADOS2 
SET SALARIO = 100
WHERE DNI='28198453C';

SELECT * FROM CONTROLCAMBIOS c;

--Ejercicio 8
--Crea la siguiente tabla:
CREATE TABLE pedidos
( CODIGOPEDIDO NUMBER,
FECHAPEDIDO DATE,
FECHAESPERADA DATE,
FECHAENTREGA DATE DEFAULT NULL,
ESTADO VARCHAR2(15),
COMENTARIOS CLOB,
CODIGOCLIENTE NUMBER
);
--Inserta los siguientes registros:
INSERT INTO PEDIDOS(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
VALUES(1,TO_DATE('17/01/06','DD/MM/YY'),TO_DATE('19/01/06','DD/MM/YY'),TO_DATE('19/01/06','DD/MM/YY'),'ENTREGADO',5);
INSERT INTO PEDIDOS(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
VALUES(2,TO_DATE('23/10/07','DD/MM/YY'),TO_DATE('28/10/07','DD/MM/YY'),TO_DATE('26/10/07','DD/MM/YY'),'ENTREGADO',5);
INSERT INTO PEDIDOS(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
VALUES(3,TO_DATE('20/06/08','DD/MM/YY'),TO_DATE('25/06/08','DD/MM/YY'),NULL,'RECHAZADO',5);
INSERT INTO PEDIDOS(CODIGOPEDIDO,FECHAPEDIDO,FECHAESPERADA,FECHAENTREGA,ESTADO,CODIGOCLIENTE)
VALUES(4,TO_DATE('20/01/09','DD/MM/YY'),TO_DATE('26/01/09','DD/MM/YY'),NULL,'PENDIENTE',5);
--Crea un trigger que al actualizar la columna fechaentrega de pedidos la compare con la
--fechaesperada.
--• Si fechaentrega es menor que fechaesperada añadirá a los comentarios 'Pedido
--entregado antes de lo esperado'.
--• Si fechaentrega es mayor que fechaesperada añadir a los comentarios 'Pedido
--entregado con retraso'.
CREATE OR REPLACE TRIGGER EJERCICIO8
	AFTER UPDATE OF FECHAENTREGA ON PEDIDOS
	FOR EACH ROW
DECLARE 
	COM CLOB;
BEGIN
	IF(:NEW.FECHAENTREGA < :OLD.FECHAESPERADA) THEN
		COM:='PEDIDO ENTREGADO ANTES DE LO ESPERADO';
	ELSIF (:NEW.FECHAENTREGA > :OLD.FECHAESPERADA) THEN
		COM:='PEDIDO ENTREGADO CON RETRASO';
	END IF;
	UPDATE PEDIDOS
	SET COMENTARIOS=COM
	WHERE FECHAESPERADA=:OLD.FECHAESPERADA;
END;

--Ejercicio 9
--Modifica el trigger anterior pero solo se ejecute si fechaentrega es mayor que
--fechaesperada
CREATE OR REPLACE TRIGGER EJERCICIO9
	AFTER UPDATE OF FECHAENTREGA ON PEDIDOS
	FOR EACH ROW
DECLARE 
	COM CLOB;
BEGIN
	IF(:NEW.FECHAENTREGA > :OLD.FECHAESPERADA) THEN
		COM:='PEDIDO ENTREGADO CON RETRASO';
	END IF;
	UPDATE PEDIDOS
	SET COMENTARIOS=COM
	WHERE FECHAESPERADA=:OLD.FECHAESPERADA;
END;
