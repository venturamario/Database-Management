-- ===================================================================================
-- ====================== Mario Ventura Burgos - 43223476J ===========================
-- ================= Sistemas de gestión de base de datos ============================
-- ============== Código usado para la realización del proyecto final ================
-- ===================================================================================

-- ===================================================================================
-- CREACIÓN FDW

-- 1. Instalación de FDW en PostgreSQL
sudo apt-get install postgresql-16-mysql-fdw

-- 2. Creación de un servidor FDW en PostgreSQL
SHOW GLOBAL VARIABLES LIKE 'PORT';
CREATE EXTENSION mysql_fdw;
CREATE SERVER mysql_server
FOREIGN DATA WRAPPER mysql_fdw
OPTIONS (host 'localhost', port '3306');

-- 3. Creación de un usuario de mapeo en PostgreSQL
CREATE USER MAPPING FOR postgres
SERVER mysql_server
OPTIONS (username 'MIGBD', password 'migbd_user_paswd');

-- 4.Importación de las tablas de MySQL
-- Tabla APODERAT
CREATE FOREIGN TABLE APODERAT (
    ideapo VARCHAR(10)  -- Identificador del apoderado (màxim 10 dígits)
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'APODERAT');

-- Tabla UBICACION
CREATE FOREIGN TABLE UBICACION (
    ideubi INTEGER,         -- Identificador de la ubicación
    nompai VARCHAR(40),     -- Nombre del país
    nomciu VARCHAR(50)      -- Nombre de la ciutat
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'UBICACION');

-- Tabla RAMADERIA
CREATE FOREIGN TABLE RAMADERIA (
    cifram VARCHAR(3),      -- CIF de la ramaderia
    nomram VARCHAR(50)      -- Nombre de la ramaderia
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'RAMADERIA');

-- Tabla FERIA
CREATE FOREIGN TABLE FERIA (
    fircor  VARCHAR(50)     -- Nombre de la festa o feria
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'FERIA');

-- Tabla PERSONA
CREATE FOREIGN TABLE PERSONA (
    ideper VARCHAR(10),     -- Identificador de la persona
    ideubi INTEGER,         -- id de la ubicacion
    nompe VARCHAR(50),      -- Nombre de la persona
    co1pe VARCHAR(50),      -- Primer apellido de la persona
    co2pe VARCHAR(50),      -- Segundo apellido de la persona
    maiper VARCHAR(100),    -- Mail de la persona
    dirper VARCHAR(100)     -- Dirección de la persona
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'PERSONA');

-- Tabla PLAZA
CREATE FOREIGN TABLE PLAZA (
    nompla VARCHAR(50),     -- Nombre de la plaza
    ideubi INT,             -- id de la ubicacion
    anypla DATE,            -- Año de construcción de la plaza
    locpla INT,             -- Número de asientos de la plaza
    tippla BOOLEAN,         -- Si la plaza es fija o movil
    estpla TEXT,            -- Estilos predominantes en la construcción
    muspla BOOLEAN          -- Indica si la plaza contiene un museo 
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'PLAZA');

-- Tabla TORERO
CREATE FOREIGN TABLE TORERO (
    idetor VARCHAR(10),     -- Identificador del torero (máximo 10 dígits)
    ideapo VARCHAR(10)      -- id del apoderado del torero
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'TORERO');

-- Tabla ACTUACION
CREATE FOREIGN TABLE ACTUACION (
    ideact INT,             -- Identificador de la actuación
    idetor VARCHAR(10),     -- id del torero que actua
    nompla VARCHAR(50),     -- nombre de la plaza de la actuacion
    datcor DATE             -- Fecha de la actuación
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'ACTUACION');

-- Tabla TORO
CREATE FOREIGN TABLE TORO (
    idtoro INT,             -- Identificador del toro
    cifram VARCHAR(3),      -- ramaderia a la que pertenece el toro
    nombou VARCHAR(50),     -- Nombre o identificación del toro
    anybou DATE,            -- Año de nacimiento del toro
    pesbou DECIMAL(10,2)    -- Peso del toro
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'TORO');

-- Tabla ESDEVENIMENT
CREATE FOREIGN TABLE ESDEVENIMENT (
    ideesd INT,             -- Identificador del esdeveniment
    fircor VARCHAR(50),     -- feria en la que se celebro el esdeveniment  
    nompla VARCHAR(50),     -- nombre de la plaza del esdeveniment
    datcor DATE             -- Fecha del esdeveniment
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'ESDEVENIMENT');

-- Tabla R_ESDEVENIMENT_TORO
CREATE FOREIGN TABLE R_ESDEVENIMENT_TORO (
    idtoro INT,     -- id del toro
    ideesd INT      -- id del esdeveniment
) SERVER mysql_server OPTIONS (dbname 'DEFBD', table_name 'R_ESDEVENIMENT_TORO');


-- Comprobación con consultas
-- Primeros 10 esdeveniments por fecha
SELECT *
FROM ESDEVENIMENT
ORDER BY datcor DESC
LIMIT 10;

-- Id del torero con apoderado 00002777V
SELECT TOR.idetor AS ID
FROM TORERO TOR
WHERE TOR.ideapo = '00002777V';

-- Cantidad de filas en apoderat
SELECT COUNT(*) FROM APODERAT;

-- ===================================================================================
-- CREACIÓN DEL TABLESPACE
-- Manejo de permisos
sudo chown postgres:postgres /tablespace
ls -ld /tablespace

-- Creación tablespace
CREATE TABLESPACE Data
OWNER postgres
LOCATION '/tablespace';

-- ===================================================================================
-- CREACIÓN DE LA BD FET
CREATE DATABASE FET
WITH ENCODING 'UTF8'
LC_COLLATE 'es_ES.utf-8'
TEMPLATE template0
TABLESPACE data;

-- ===================================================================================
-- Creación del esquema temp
CREATE SCHEMA Temp;
-- Operaciones dentro del esquema
SET SEARCH_PATH = Temp;
-- Comprobaciçon de path establecido coprrectamente
SHOW SEARCH_PATH;

-- ===================================================================================
-- Creación del usuario UFDW
CREATE USER UFDW WITH PASSWORD 'ufdw_user_passwd';
-- Otorgar permisos de conexión
GRANT CONNECT ON DATABASE FET TO UFDW;
-- Creación y uso del esquema
GRANT CREATE, USAGE ON SCHEMA Temp TO UFDW;
-- Otorgar permisos para seleccionar e insertar en todas las tablas del esquema
GRANT INSERT, SELECT ON ALL TABLES IN SCHEMA Temp TO UFDW;

-- Creación tablas

-- ===================================================================================
-- Consultas desde PostgreSQL a MySQL con FDW
-- Media de peso de toros lidiados en españa y agrupados por año
SELECT EXTRACT(YEAR FROM E.DATCOR) AS AÑO, AVG(T.PESBOU) AS PESO
FROM ESDEVENIMENT E
    JOIN R_ESDEVENIMENT_TORO ET
    ON E.IDEESD = ET.IDEESD
        JOIN TORO T
        ON ET.IDTORO = T.IDTORO
GROUP BY AÑO
ORDER BY AÑO DESC; -- LIMIT 25 (quitar ; del ORDER BY);

-- Número de toros lidiados en España
SELECT COUNT(DISTINCT T.IDTORO) AS NUM_TOROS
FROM ESDEVENIMENT E
    JOIN R_ESDEVENIMENT_TORO ET
    ON E.IDEESD = ET.IDEESD
        JOIN TORO T
        ON ET.IDTORO = T.IDTORO
    JOIN PLAZA PL
    ON E.NOMPLA = PL.NOMPLA
        JOIN UBICACION UBI
        ON PL.IDEUBI = UBI.IDEUBI AND UBI.NOMPAI = 'España';