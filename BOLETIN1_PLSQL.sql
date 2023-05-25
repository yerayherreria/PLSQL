--Boletín Introducción a Procedimientos y Funciones
--1. Crea un procedimiento llamado ESCRIBE para mostrar por pantalla el
--mensaje HOLA MUNDO.
CREATE OR REPLACE
PROCEDURE ESCRIBE 
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE ('HOLA MUNDO');
END ESCRIBE;

BEGIN 
	ESCRIBE;
END;

--2. Crea un procedimiento llamado ESCRIBE_MENSAJE que tenga un
--parámetro de tipo VARCHAR2 que recibe un texto y lo muestre por pantalla.
--La forma del procedimiento ser. la siguiente:
--ESCRIBE_MENSAJE (mensaje VARCHAR2)
CREATE OR REPLACE
PROCEDURE ESCRIBE_MENSAJE (mensaje VARCHAR2) 
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE (MENSAJE);
END;

BEGIN 
	ESCRIBE_MENSAJE ('CURRO');
END;

--3. Crea un procedimiento llamado SERIE que muestre por pantalla una serie de
--números desde un mínimo hasta un máximo con un determinado paso. La
--forma del procedimiento ser. la siguiente:
--SERIE (minimo NUMBER, maximo NUMBER, paso NUMBER)
CREATE OR REPLACE 
PROCEDURE SERIE (MINIMO NUMBER, MAXIMO NUMBER, PASO NUMBER)
AS 
	I NUMBER(10):=MINIMO;
BEGIN 
	WHILE (I<=MAXIMO) LOOP
		dbms_output.put_line(i);
		I:=I+PASO;
	END LOOP;
END;

BEGIN 
	SERIE (0,10,2);
END;

--4. Crea una función AZAR que reciba dos parámetros y genere un número al
--azar entre un mínimo y máximo indicado. La forma de la función será la
--siguiente:
--AZAR (minimo NUMBER, maximo NUMBER) RETURN NUMBER
CREATE OR REPLACE FUNCTION AZAR(minimo NUMBER, maximo NUMBER) 
RETURN NUMBER 
IS
BEGIN
    RETURN TRUNC(dbms_random.VALUE(minimo,maximo)) ;
END AZAR;

SELECT AZAR(4, 10) FROM DUAL;

--5. Crea una función NOTA que reciba un parámetro que será una nota numérica
--entre 0 y 10 y devuelva una cadena de texto con la calificación (Suficiente,
--Bien, Notable, ...). La forma de la función será la siguiente:
--NOTA (nota NUMBER) RETURN VARCHAR2
CREATE OR REPLACE FUNCTION NOTA (NOTA NUMBER)
RETURN VARCHAR2
IS
BEGIN 
	IF (NOTA < 5) THEN
		RETURN ('Insuficiente');
	ELSIF (NOTA = 5) THEN
		RETURN ('Suficiente');
	ELSIF (NOTA > 5 AND NOTA <7) THEN
		RETURN ('Bien');
	ELSIF (NOTA >= 7 AND NOTA <=8) THEN
		RETURN ('Notable');
	ELSIF (NOTA > 8 AND NOTA <=10) THEN
		RETURN ('Sobresaliente');
	END IF;
END;

SELECT NOTA(7) FROM DUAL;