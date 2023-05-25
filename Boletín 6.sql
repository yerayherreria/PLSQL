--1. Realizar un procedure que se llame insertar_alumno, que recibirá como parámetro el nombre y apellido de una persona, e inserte de forma automática esa persona como alumno.
CREATE OR REPLACE 
PROCEDURE Insertar_alumno(NOMBRE_ALU VARCHAR2, APELLIDO_ALU VARCHAR2) 
IS
	ID_ALU VARCHAR2(50);
	DNI_ALU VARCHAR2(50);
BEGIN
	SELECT P.DNI INTO DNI_ALU
	FROM PERSONA p 
	WHERE P.NOMBRE LIKE NOMBRE_ALU
	AND P.APELLIDO LIKE APELLIDO_ALU;	

	SELECT TO_CHAR(MAX(TO_NUMBER(SUBSTR(A.IDALUMNO,2))+1)) INTO ID_ALU
	FROM ALUMNO a;
	
	INSERT INTO ALUMNO a VALUES('A'||ID_ALU,DNI_ALU);
	
END;

--2. Realizar una función que reciba como parámetro el nombre y el apellido de una persona, también debe recibir un parámetro que podrá ser un 1 (en ese caso debe insertarlo como un alumno) o un 2 (debe insertarlo como profesor), y un parámetro de entrada salida en el que deberá devolver el código del profesor o alumno insertado. La función deberá devolver un 1 si se ha podido realizar la inserción, y un cero si ha ocurrido algún error.
CREATE OR REPLACE 
FUNCTION INSERTAR_PROFESO(NOMBRE_PRO VARCHAR2, APELLIDO_PRO VARCHAR2) RETURN NUMBER
IS
	ID_PRO VARCHAR2(50);
	DNI_ALU VARCHAR2(50);
	NUM NUMBER:=1;
BEGIN
	--Compruebo si el profesor existe
	SELECT P.DNI INTO DNI_ALU
	FROM PERSONA p 
	WHERE P.NOMBRE LIKE NOMBRE_PRO
	AND P.APELLIDO LIKE APELLIDO_PRO;	

	SELECT TO_CHAR(MAX(TO_NUMBER(SUBSTR(p.IDPROFESOR ,2))+1)) INTO ID_PRO
	FROM PROFESOR p ;
	
	IF SQL%NOTFOUND THEN
		NUM:=0;
	END IF;
	INSERT INTO PROFESOR P VALUES('P'||ID_PRO,DNI_ALU);
	RETURN NUM;
END;

--3. Crear un procedure para que se llame tres o más veces a la función anterior, mostrando el mensaje “El alumno XXXX ha sido insertado”, o “El alumno XXXX no ha sido insertado, y lo mismo con profesores donde XXXX será el dato concreto.
CREATE OR REPLACE PROCEDURE EJER3
IS 
	NUM NUMBER;
BEGIN 
	FOR I IN 1..3 LOOP 
		NUM:= INSERTAR_PROFESO('YERAY','HERRERIA');
	
		IF NUM = 1 THEN
			DBMS_OUTPUT.PUT_LINE('El profesor XXXX ha sido insertado');
		ELSE
			DBMS_OUTPUT.PUT_LINE('El profesor XXXX no ha sido insertado');
		END IF;
	END LOOP;
END;

--4. Realizar una función que devuelva un uno o un cero, si el alumno con dni que se le pasa como argumento está matriculado en la asignatura cuyo nombre se le pasa también como argumento. La función también deberá tener un parámetro de entrada salida en donde se devuelva el nombre y apellido del profesor que le da clase en esa asignatura, si el alumno está matriculado. Procedure o bloque anónimo para comprobar que funciona.
CREATE OR REPLACE FUNCTION ESTAMATRICULADO(DNI_V VARCHAR2, ASIGNATURA_V VARCHAR2, NOMBREAPELLIDOPROF IN OUT VARCHAR2) RETURN NUMBER 
AS 
	ID_ALU VARCHAR2(50);
	ID_ASIG VARCHAR2(50);
	ESTAMATRICULADO NUMBER;
	NUM NUMBER:=0;
BEGIN 
    SELECT A.IDALUMNO INTO ID_ALU
    FROM ALUMNO A
    WHERE A.DNI = DNI_V;

    SELECT A.IDASIGNATURA INTO ID_ASIG
    FROM ASIGNATURA A 
    WHERE A.NOMBRE LIKE ASIGNATURA_V;

    SELECT COUNT(*) INTO ESTAMATRICULADO
    FROM ALUMNO_ASIGNATURA AA 
    WHERE AA.IDALUMNO LIKE ID_ALU AND AA.IDASIGNATURA LIKE ID_ASIG;

    IF ESTAMATRICULADO>0 THEN
	    SELECT P.NOMBRE || ' ' || P.APELLIDO INTO NOMBREAPELLIDOPROF
	    FROM PERSONA P , PROFESOR P2 , ASIGNATURA A 
	    WHERE P.DNI = P2.DNI AND P2.IDPROFESOR = A.IDASIGNATURA ;
        NUM:=1;
    END IF;
    RETURN NUM;

END;


DECLARE 
BEGIN
	DBMS_OUTPUT.PUT_LINE(ESTAMATRICULADO('17171717A','Contabilidad'));
END;

--5. Realizar una función que devuelva un 1 si el nombre y apellido de la persona que se le pasa por parámetro es un alumno, un dos si es un profesor y un 0 si no está en la base de datos.
CREATE OR REPLACE FUNCTION COMPROBAR_EXISTENCIA(NOMBRE_V VARCHAR2, APELLIDO_V VARCHAR2)
RETURN NUMBER
IS 
	EXISTE_ALU NUMBER;
	EXISTE_PRO NUMBER;
	NUM NUMBER :=0;
BEGIN 
	
	SELECT COUNT(P2.DNI) INTO EXISTE_PRO
	FROM PERSONA p, PROFESOR p2 
	WHERE P.DNI = P2.DNI
	AND P.NOMBRE LIKE NOMBRE_V
	AND P.APELLIDO LIKE APELLIDO_V;

	SELECT COUNT(P.DNI) INTO EXISTE_ALU
	FROM PERSONA p, ALUMNO a 
	WHERE P.DNI = A.DNI
	AND P.NOMBRE LIKE NOMBRE_V
	AND P.APELLIDO LIKE APELLIDO_V;


	IF EXISTE_ALU > 0 AND EXISTE_PRO=0 THEN
		NUM := 1;
	ELSIF EXISTE_PRO > 0 AND EXISTE_ALU=0 THEN
		NUM := 2;
	END IF;
	
	RETURN NUM;
END;

SELECT COMPROBAR_EXISTENCIA('Luis','Ramirez') FROM dual;

--6. Crear un procedure que reciba como parámetro el nombre de una titulación, el nombre de la asignatura, y el nombre y apellido del profesor (en dos parámetros distintos), y que inserte esos datos en la tabla de asignatura. Si se produce un error notificarlo. Los errores que deben notificarse son:
--• No existe la titulación
--• No existe la personas
--• La persona no es un profesor
--• El nombre de la asignatura ya está en la base de datos.
CREATE OR REPLACE PROCEDURE UNIVERSIDAD.CREAR_ASIGNATURA (NOMBRE_TITU VARCHAR2, NOMBRE_ASIG VARCHAR2, NOMBRE_PRO VARCHAR2, APELLIDO_PRO VARCHAR2)
IS 
	EXISTE_TITULACION NUMBER;
	EXISTE_PERSONA NUMBER;
	PERSONA_ES_PROFESOR NUMBER;
	EXISTE_ASIG NUMBER;
	COD_ASIGNATURA VARCHAR2(50);
	ID_PROFESOR VARCHAR2(50);
	ID_TITU VARCHAR2(50);
BEGIN 
	
	SELECT COUNT(P.DNI) INTO EXISTE_PERSONA
	FROM PERSONA p
	WHERE P.NOMBRE LIKE NOMBRE_PRO
	AND P.APELLIDO LIKE APELLIDO_PRO;

	SELECT COUNT(T.IDTITULACION) INTO EXISTE_TITULACION
	FROM TITULACION t 
	WHERE T.NOMBRE LIKE NOMBRE_TITU;

	SELECT COUNT(P.DNI) INTO PERSONA_ES_PROFESOR
	FROM PERSONA p, PROFESOR p2 
	WHERE P.DNI = P2.DNI 
	AND P.NOMBRE LIKE NOMBRE_PRO
	AND P.APELLIDO LIKE APELLIDO_PRO;

	SELECT COUNT(A.IDASIGNATURA) INTO EXISTE_ASIG
	FROM ASIGNATURA a 
	WHERE A.NOMBRE LIKE NOMBRE_ASIG;

	IF EXISTE_PERSONA = 0 THEN
		RAISE_APPLICATION_ERROR(-20001, 'No existe persona');
	ELSIF EXISTE_TITULACION = 0 THEN 
		RAISE_APPLICATION_ERROR(-20002, 'No existe titulacion');
	ELSIF PERSONA_ES_PROFESOR = 0 THEN 
		RAISE_APPLICATION_ERROR(-20003, 'Esa persona no es profesor');	
	ELSIF EXISTE_ASIG > 0 THEN 
		RAISE_APPLICATION_ERROR(-20004, 'Esa asignatura ya existe en la base de datos');
	ELSE
		SELECT TO_CHAR(MIN(TO_NUMBER(A.IDASIGNATURA)+1)) INTO COD_ASIGNATURA
		FROM ASIGNATURA a;
		
		SELECT P2.IDPROFESOR INTO ID_PROFESOR
		FROM PERSONA p, PROFESOR p2 
		WHERE P.DNI = P2.DNI 
		AND P.NOMBRE LIKE NOMBRE_PRO
		AND P.APELLIDO LIKE APELLIDO_PRO;
	
		SELECT T.IDTITULACION INTO ID_TITU
		FROM TITULACION t 
		WHERE T.NOMBRE LIKE NOMBRE_TITU;
		
		INSERT INTO ASIGNATURA VALUES (COD_ASIGNATURA,NOMBRE_ASIG,2,1,60,ID_PROFESOR,ID_TITU,2);
	END IF;
END;

SELECT *
FROM ASIGNATURA a;

BEGIN
	CREAR_ASIGNATURA('Matematicas', 'Seguridad Via', 'CURRO', 'CURRUQUERO');
END;
--INSERT INTO PERSONA P VALUES ('11223344A','CURRO','CURRUQUERO','SEVILLA','TRA TRA',1,123456789,SYSDATE,1);

--7. Realizar una función que reciba un nombre de titulación y un porcentaje, y que realice la subida del precio en el porcentaje indicado de las asignaturas de esa titulación. La función también recibirá un parámetro de entrada salida en la que debe devolver la cantidad total que se ha subido en todas las asignaturas. La función debe devolver el número de asignatura que hay en esa titulación o un -1 si no hay ninguna.
CREATE OR REPLACE FUNCTION SUBIDA_PRECIO(TITULACION_V VARCHAR2, PORCENTAJE NUMBER, SUBIDATOTAL IN OUT NUMBER) RETURN NUMBER 
AS 
	CURSOR ASIGNATURAS(NOM_TITULACION VARCHAR2)
IS
	SELECT A.COSTEBASICO AS COSTE
	FROM ASIGNATURA A , TITULACION T 
	WHERE T.NOMBRE = NOM_TITULACION AND T.IDTITULACION = A.IDASIGNATURA ;
	CONTADOR NUMBER:=-1;
BEGIN 
    FOR ASIG IN ASIGNATURAS(TITULACION_V) LOOP
        SUBIDATOTAL:=SUBIDATOTAL+(ASIG.COSTEPORCENTAJE);
        UPDATE ASIGNATURA A SET A.COSTEBASICO = ASIG.COSTE + (ASIG.COSTEPORCENTAJE);
        CONTADOR:=CONTADOR+1;
    END LOOP;
    
   IF CONTADOR>-1 THEN
    CONTADOR:=CONTADOR+1;
    END IF;
	RETURN CONTADOR;
END;