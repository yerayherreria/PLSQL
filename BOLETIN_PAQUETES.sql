--5.6.1. Desarrolla el paquete ARITMETICA cuyo código fuente viene en este tema.
--Crea un archivo para la especi(cación y otro para el cuerpo. Realiza varias pruebas
--para comprobar que las llamadas a funciones y procedimiento funcionan
--correctamente.
CREATE OR REPLACE
PACKAGE aritmetica IS
  version NUMBER := 1.0;

  PROCEDURE mostrar_info;
  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER;
END aritmetica;

CREATE OR REPLACE
PACKAGE BODY aritmetica IS

  PROCEDURE mostrar_info IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
  END mostrar_info;

  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a+b);
  END suma;

  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a-b);
  END resta;

  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a*b);
  END multiplica;

  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a/b);
  END divide;

END aritmetica;

SELECT ARITMETICA.SUMA(2,3) FROM DUAL;
SELECT ARITMETICA.RESTA(4,2) FROM DUAL;
SELECT ARITMETICA.MULTIPLICA(3,4) FROM DUAL;
SELECT ARITMETICA.DIVIDE(2,2) FROM DUAL;
--5.6.2. Al paquete anterior añade una función llamada RESTO que reciba dos
--parámetros, el dividendo y el divisor, y devuelva el resto de la división.
CREATE OR REPLACE
PACKAGE aritmetica IS
  version NUMBER := 1.0;

  PROCEDURE mostrar_info;
  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION resto     (a NUMBER, b NUMBER) RETURN NUMBER;
END aritmetica;

CREATE OR REPLACE
PACKAGE BODY aritmetica IS

  PROCEDURE mostrar_info IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
  END mostrar_info;

  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a+b);
  END suma;

  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a-b);
  END resta;

  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a*b);
  END multiplica;

  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a/b);
  END divide;
  FUNCTION resto     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (MOD(a,b));
  END resto;

END aritmetica;
SELECT ARITMETICA.RESTO(13,5) FROM DUAL;
--5.6.3. Al paquete anterior añade un procedimiento sin parámetros llamado AYUDA
--que muestre un mensaje por pantalla de los procedimientos y funciones disponibles
--en el paquete, su utilidad y forma de uso.
CREATE OR REPLACE
PACKAGE aritmetica IS
  version NUMBER := 1.0;

  PROCEDURE mostrar_info;
  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER;
  FUNCTION resto     (a NUMBER, b NUMBER) RETURN NUMBER;
  PROCEDURE AYUDA;
END aritmetica;

CREATE OR REPLACE
PACKAGE BODY aritmetica IS

  PROCEDURE mostrar_info IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
  END mostrar_info;

  FUNCTION suma       (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a+b);
  END suma;

  FUNCTION resta      (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a-b);
  END resta;

  FUNCTION multiplica (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a*b);
  END multiplica;

  FUNCTION divide     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (a/b);
  END divide;
 
  FUNCTION resto     (a NUMBER, b NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN (MOD(a,b));
  END resto;

  PROCEDURE AYUDA IS
  BEGIN
     DBMS_OUTPUT.PUT_LINE
      ('Paquete de operaciones aritméticas. Versión ' || version);
     DBMS_OUTPUT.PUT_LINE
      ('FUNCIÓN DE SUMAR');
     DBMS_OUTPUT.PUT_LINE
      ('FUNCIÓN DE RESTAR');
     DBMS_OUTPUT.PUT_LINE
      ('FUNCIÓN DE MULTIPLICAR');
     DBMS_OUTPUT.PUT_LINE
      ('FUNCIÓN DE DIVIDIR');
     DBMS_OUTPUT.PUT_LINE
      ('FUNCIÓN DE RESTO');
  END AYUDA;
END aritmetica;
BEGIN
	aritmetica.AYUDA;
END;

--5.6.4. Desarrolla el paquete GESTION. En un principio tendremos los
--procedimientos para gestionar los departamentos. Dado el archivo de
--especi(cación mostrado más abajo crea el archivo para el cuerpo. Realiza varias
--pruebas para comprobar que las llamadas a funciones y procedimientos funcionan
--correctamente.

CREATE OR REPLACE
PACKAGE GESTION AS
 PROCEDURE CREAR_DEP (nombre VARCHAR2, presupuesto NUMBER);
 FUNCTION NUM_DEP (nombre VARCHAR2) RETURN NUMBER;
 PROCEDURE MOSTRAR_DEP (numero NUMBER);
 PROCEDURE BORRAR_DEP (numero NUMBER);
 PROCEDURE MODIFICAR_DEP (numero NUMBER, presupuesto NUMBER);
END GESTION;

CREATE OR REPLACE
PACKAGE BODY GESTION IS
  PROCEDURE CREAR_DEP (nombre VARCHAR2, presupuesto NUMBER) IS
  BEGIN
    INSERT INTO DEPT (DEPTNO,DNAME)
    VALUES (presupuesto,NOMBRE);
  END CREAR_DEP;
 
  FUNCTION NUM_DEP (nombre VARCHAR2) RETURN NUMBER IS
  DEPT_NUM DEPT.DEPTNO%TYPE;
  BEGIN
	SELECT D.DEPTNO INTO DEPT_NUM
	FROM DEPT d 
	WHERE D.DNAME LIKE nombre;
    RETURN DEPT_NUM;
  END NUM_DEP;
 
  PROCEDURE MOSTRAR_DEP (numero NUMBER) IS
  DEPT_NOM DEPT.DNAME%TYPE;
  BEGIN
    SELECT D.DNAME INTO DEPT_NOM
	FROM DEPT d 
	WHERE D.DEPTNO = numero;
	DBMS_OUTPUT.PUT_LINE
      (DEPT_NOM);
  END MOSTRAR_DEP;
 
  PROCEDURE BORRAR_DEP (numero NUMBER) IS
  BEGIN
    DELETE FROM DEPT d 
    WHERE D.DEPTNO = numero;
  END BORRAR_DEP;
 
  PROCEDURE MODIFICAR_DEP (numero NUMBER, presupuesto NUMBER) IS
  BEGIN
    UPDATE DEPT d
    SET D.DEPTNO = presupuesto
    WHERE D.DEPTNO = numero;
  END MODIFICAR_DEP;
END GESTION;


BEGIN
	GESTION.CREAR_DEP('CURRO',1);
END;
SELECT GESTION.NUM_DEP('ACCOUNTING') FROM DUAL; 
BEGIN
	GESTION.MOSTRAR_DEP(10);
END;
BEGIN
	GESTION.BORRAR_DEP(20);
END;
BEGIN
	GESTION.MODIFICAR_DEP(10,11);
END;