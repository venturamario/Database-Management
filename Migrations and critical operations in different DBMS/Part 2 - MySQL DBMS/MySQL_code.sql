-- ===================================================================================
-- ====================== Mario Ventura Burgos - 43223476J ===========================
-- ================= Sistemas de gestión de base de datos ============================
-- ============== Código usado para la realización del proyecto final ================
-- ===================================================================================

-- ===========================================================================================================================
-- Creación del tablespace
CREATE TABLESPACE my_tablespace
INITIAL_SIZE=5G
MAX_SIZE=10G;

-- ===========================================================================================================================
-- Posibles character sets y collations
SHOW CHARACTER SET;

-- Creación BD
CREATE DATABASE IMPBD
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Mostrar BDs disponibles	
SHOW DATABASES;

-- ===========================================================================================================================
-- Usuario Impbd
CREATE USER 'IMPBD'@'localhost' IDENTIFIED BY 'impbd_user_passwd';
-- Permisos
GRANT CREATE, INSERT, UPDATE, DELETE ON IMPBD.* TO 'IMPBD'@'localhost';
-- Comprobar los permisos del usuario
SHOW GRANTS FOR 'IMPBD'@'localhost';


-- ===========================================================================================================================
-- Usaremos estas tablas para desarrollar el modelo nuevo y comprobar mediante
-- consultas multiplicidades entre las clases del modelo descrito en el enunciado 

-- TABLA DE APODERADO
CREATE TABLE APODERAT(
	IDEAPO VARCHAR(10),
    NOMAPO VARCHAR(50),
    CO1APO VARCHAR(50),
    CO2APO VARCHAR(50),
    MAIAPO VARCHAR(100),
    DIRAPO VARCHAR(100),
    CIUAPO VARCHAR(50),
    PAIAPO VARCHAR(40)) TABLESPACE my_tablespace;

-- TABLA DE PLAZA
CREATE TABLE PLAZA(
	NOMPLA VARCHAR(50),
	ANYPLA DATE,
	LOCPLA INT,
	TIPPLA BOOLEAN,
	CIUPLA VARCHAR(50),
	PAIPLA VARCHAR(50),
	ESTPLA TEXT NULL,
	MUSPLA BOOLEAN) TABLESPACE my_tablespace;

-- TABLA DE TORERO
CREATE TABLE TORERO(
	IDETOR VARCHAR(10),
	NOMTOR VARCHAR(50),
	CO1TOR VARCHAR(50),
	CO2TOR VARCHAR(50),
	MAITOR VARCHAR(100),
	DIRTOR VARCHAR(100),
	CIUTOR VARCHAR(50),
	PAITOR VARCHAR(40),
	IDEAPO VARCHAR(10)) TABLESPACE my_tablespace;

-- TABLA DE ACTUACION
CREATE TABLE ACTUACIO(
	IDETOR VARCHAR(10),
	DATCOR DATE,
	NOMPLA VARCHAR(50)) TABLESPACE my_tablespace;

-- TABLA DE ESDEVENIMENT
CREATE TABLE ESDEVENIMENT(
	FIRCOR VARCHAR(50),
	DATCOR DATE,
	NOMPLA VARCHAR(50),
	NOMBOU VARCHAR(50),
	ANYBOU DATE,
	PESBOU DECIMAL(10,2),
	CIFRAM VARCHAR(3),
	NOMRAM VARCHAR(50)) TABLESPACE my_tablespace;

-- ===========================================================================================================================
-- Antes de ejecutar scripts python
-- USE IMPBD -- si no estamos conectados aún
STATUS;

-- Comprobamos qué character set es cp850
SHOW CHARACTER SET;

-- Cambiamos character set
SET NAMES 'utf8mb4';
SET CHARACTER SET 'utf8mb4';

-- Comprobamos que los cambios se han realizado correctamente
STATUS;
SHOW VARIABLES LIKE 'character_set_client';
SHOW VARIABLES LIKE 'character_set_connection';

-- ===========================================================================================================================
-- Creación de la base de datos DEFBD;
CREATE DATABASE DEFBD
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- Mostrar BDs disponibles	
SHOW DATABASES;

-- ===========================================================================================================================
-- Usuario Impbd
CREATE USER 'MIGBD'@'localhost' IDENTIFIED BY 'migbd_user_passwd';
-- Permisos
GRANT CREATE, INSERT, UPDATE, DELETE, SELECT, REFERENCES ON DEFBD.* TO 'MIGBD'@'localhost';
-- Comprobar los permisos del usuario
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'MIGBD'@'localhost';

-- ===========================================================================================================================
-- Acceso con MIGBD y accedemos a la bd
-- mysql -u MIGBD -p 
USE DEFBD;

-- Creación de las tablas 
-- Comprobación de que las tablas se han creado
SHOW TABLES;

-- ===========================================================================================================================
-- Para realizar scripts de traspaso de info, se necesitan privilegios de lectura en IMPBD
GRANT SELECT ON impbd.* TO 'MIGBD'@'localhost';
-- Actualizamos privilegios por seguridad
FLUSH PRIVILEGES;
-- Comprobamos que se ha añadido el permiso
SHOW GRANTS FOR 'MIGBD'@'localhost';

-- ===========================================================================================================================
-- Modificar tabla persona para que co2pe pueda ser NULL
ALTER TABLE PERSONA
MODIFY COLUMN co2pe VARCHAR(50) NULL;

-- Darle permiso ALTER (necesario usuario root)
USE DEFBD;
GRANT ALTER ON DEFBD.* TO 'MIGBD'@'localhost';
FLUSH PRIVILEGES;

-- Modificar tabla persona
ALTER TABLE PERSONA
MODIFY COLUMN co2pe VARCHAR(50) NULL;
-- Se observa lo mismo para maiper
ALTER TABLE PERSONA
MODIFY COLUMN maiper VARCHAR(100) NULL;

-- Quitamos permisos a MIGBD
REVOKE ALTER ON *.* FROM 'MIGBD'@'localhost';

-- ===========================================================================================================================
-- Seleccionamos los toros con menos de dos años y medio
SELECT DISTINCT TOR.IDTORO, TOR.NOMBOU, TOR.ANYBOU, ESD.DATCOR
FROM TORO TOR
    JOIN R_ESDEVENIMENT_TORO ET
	ON TOR.IDTORO = ET.IDTORO
        JOIN ESDEVENIMENT ESD
		ON ET.IDEESD = ESD.IDEESD
		-- Como son 2,5 años, debemos contar por meses o días
		-- En este caso haremos uso de la función DATEDIFF usando días
WHERE DATEDIFF(ESD.DATCOR, TOR.ANYBOU) < 912 -- 365 * 2,5 = 912,5 = 912
ORDER BY TOR.IDTORO
-- Limitamos a 100 el resultado como número orientativo
LIMIT 100;

-- Actualización de toros con menos de 2,5 años de edad
UPDATE TORO TOR
    JOIN R_ESDEVENIMENT_TORO ET
	ON TOR.IDTORO = ET.IDTORO
        JOIN ESDEVENIMENT ESD
		ON ET.IDEESD = ESD.IDEESD
-- Se usa el planteamiento de usar dos intervalos: 2 YEAR + 6 MONTH
SET ANYBOU = DATE_SUB(ESD.DATCOR, INTERVAL 2 YEAR) - INTERVAL 6 MONTH
-- 365 dias x 2'5 = 912 dias
WHERE DATEDIFF(ESD.DATCOR, TOR.ANYBOU) < 912;

-- Comprobación de actualización correcta
SELECT TOR.NOMBOU, TOR.ANYBOU, ESD.DATCOR
FROM TORO TOR
    JOIN R_ESDEVENIMENT_TORO ET
	ON TOR.IDTORO = ET.IDTORO
        JOIN ESDEVENIMENT ESD
		ON ET.IDEESD = ESD.IDEESD
-- Este toro tenia fecha de nacimiento 1671-11-07
WHERE TOR.NOMBOU = 'Alfonso' AND DATE(ESD.DATCOR) = '1673-04-15'
-- Limitamos a 1 el resultado
LIMIT 1;

SELECT TOR.NOMBOU, TOR.ANYBOU, ESD.DATCOR
FROM TORO TOR
    JOIN R_ESDEVENIMENT_TORO ET
	ON TOR.IDTORO = ET.IDTORO
        JOIN ESDEVENIMENT ESD
		ON ET.IDEESD = ESD.IDEESD
-- Este toro tenia fecha de nacimiento 1612-06-11
WHERE TOR.NOMBOU = 'Ali' AND DATE(ESD.DATCOR) = '1614-06-13'
-- Limitamos a 1 el resultado
LIMIT 1;

SELECT TOR.NOMBOU, TOR.ANYBOU, ESD.DATCOR
FROM TORO TOR
    JOIN R_ESDEVENIMENT_TORO ET
	ON TOR.IDTORO = ET.IDTORO
        JOIN ESDEVENIMENT ESD
		ON ET.IDEESD = ESD.IDEESD
-- Este toro tenia fecha de nacimiento 1612-06-11
WHERE TOR.NOMBOU = 'Allegra' AND DATE(ESD.DATCOR) = '1614-05-04'
-- Limitamos a 1 el resultado
LIMIT 1;

-- ===========================================================================================================================
-- ANÁLISIS
EXPLAIN UPDATE TORO TOR
    JOIN R_ESDEVENIMENT_TORO ET
	ON TOR.IDTORO = ET.IDTORO
        JOIN ESDEVENIMENT ESD
		ON ET.IDEESD = ESD.IDEESD
SET ANYBOU = DATE_SUB(ESD.DATCOR, INTERVAL 2 YEAR) - INTERVAL 6 MONTH
WHERE DATEDIFF(ESD.DATCOR, TOR.ANYBOU) < 912;

-- MEJORAS
-- Crear índice en la columna DATCOR de la tabla ESDEVENIMENT
CREATE INDEX idx_ESD_DATCOR ON ESDEVENIMENT (DATCOR);
-- Crear índice en la columna ANYBOU de la tabla TORO
CREATE INDEX idx_TORO_ANYBOU ON TORO (ANYBOU);