--1. Crear un procedimiento que en la tabla emp incremente el salario el 10% a los empleados que
--tengan una comisión superior al 5% del salario.
CREATE OR REPLACE PROCEDURE INCRE_SALARIO
AS 
	CURSOR EJER1 IS
	SELECT E.EMPNO
	FROM EMP e 
	WHERE E.COMM > ALL 
	(SELECT (E.SAL * 0.05)
	FROM EMP e);
BEGIN
	FOR REGISTRO IN EJER1
	LOOP
		UPDATE EMP SET SAL = SAL + (SAL * 0.05)
		WHERE EMPNO = REGISTRO.EMPNO;
	END LOOP;
END;
BEGIN
	INCRE_SALARIO;
END;

--2. Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres de los dos
--vendedores/as con más comisiones.
CREATE OR REPLACE PROCEDURE MostrarMejoresVendedores
AS
	CURSOR C_ORDENADOS IS
	SELECT E.ENAME , NVL(E.COMM, 0)
	FROM EMP e
	ORDER BY NVL(E.COMM, 0) DESC;

	CONT NUMBER:=0;
BEGIN
	FOR I IN C_ORDENADOS 
	LOOP
		IF CONT<2 THEN
			DBMS_OUTPUT.PUT_LINE(I.ENAME);
			CONT:=CONT+1;
		END IF;
	END LOOP;
END;

BEGIN
	MostrarMejoresVendedores;
END;

--3. Realiza un procedimiento MostrarsodaelpmE que reciba el nombre de un departamento al
--revés y muestre los nombres de los empleados de ese departamento.
CREATE OR REPLACE PROCEDURE MOSTRARSODAELPME(NOMBRE VARCHAR2)
AS 
	CURSOR EJER3 (NOMBRE2 VARCHAR2) IS 
	SELECT E.ENAME 
	FROM EMP e, DEPT d
	WHERE E.DEPTNO = D.DEPTNO 
	AND D.DNAME LIKE NOMBRE2;
	NOMBRE2 DEPT.DNAME%TYPE;
BEGIN
	FOR CARACTER IN REVERSE 1..LENGTH(NOMBRE)
	LOOP
		NOMBRE2 := NOMBRE2||SUBSTR(NOMBRE,CARACTER,1);
	END LOOP;

	FOR REGISTRO IN EJER3(NOMBRE2)
	LOOP
		DBMS_OUTPUT.PUT_LINE(REGISTRO.ENAME);
	END LOOP;
END;
BEGIN
	MOSTRARSODAELPME('GNITNUOCCA');
END;

--4. Realiza un procedimiento RecortarSueldos que recorte el sueldo un 20% a los empleados
--cuyo nombre empiece por la letra que recibe como parámetro. Trata las excepciones que
--consideres necesarias.
CREATE OR REPLACE PROCEDURE RECORTARSUELDOS(PARAMETRO VARCHAR2)
AS 
BEGIN
	UPDATE EMP 
	SET SAL =SAL-(SAL*0.2)
	WHERE SUBSTR(ENAME,1,1)=PARAMETRO;
	IF SQL%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO HAY EMPLEADOS.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('EMPLEADOS ACTUALIZADOS.');
	END IF;
END;
BEGIN
	RECORTARSUELDOS('A');
END;

--5. Realiza un procedimiento BorrarBecarios que borre a los dos empleados más nuevos de cada
--departamento.
CREATE OR REPLACE PROCEDURE BORRARBECARIOS
IS
    CURSOR C_DEPT
    IS
    SELECT D.DEPTNO
    FROM DEPT d;
BEGIN
    FOR V_DEPT IN C_DEPT LOOP
        BORRARDOSMASNUEVOS(V_DEPT.DEPTNO);
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE BORRARDOSMASNUEVOS(P_DEPTNO DEPT.DEPTNO%TYPE)
IS
    CURSOR C_EMP
    IS
    SELECT E.EMPNO
    FROM EMP e
    WHERE DEPTNO= P_DEPTNO
    ORDER BY HIREDATE DESC;
    V_EMP C_EMP%ROWTYPE;
BEGIN
    OPEN C_EMP;
    FETCH C_EMP INTO V_EMP;
    WHILE C_EMP%FOUND AND C_EMP%ROWCOUNT<=2 LOOP
        DELETE EMP
        WHERE EMPNO=V_EMP.EMPNO;
        FETCH C_EMP INTO V_EMP;
    END LOOP;
    CLOSE C_EMP;
END;

BEGIN
	BORRARBECARIOS;
END;
