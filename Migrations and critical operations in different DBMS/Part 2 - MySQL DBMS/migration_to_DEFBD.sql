-- ===================================================================================
-- ====================== Mario Ventura Burgos - 43223476J ===========================
-- ================= Sistemas de gestión de base de datos ============================
-- ================ Código usado para la migración de IMPBD a DEFBD ==================
-- ===================================================================================

-- ===================================================================================
-- TABLA UBICACIÓN
-- Insert en ubicación desde plaza
INSERT INTO UBICACION (NOMPAI, NOMCIU)
    SELECT DISTINCT PAIPLA, CIUPLA
    FROM IMPBD.PLAZA
    -- Comprobación de que no esté insertado en DEFBD
    WHERE (PAIPLA, CIUPLA) NOT IN (
        SELECT NOMPAI, NOMCIU
        FROM DEFBD.UBICACION
    );

-- Insert en ubicación desde torero
INSERT INTO UBICACION (NOMPAI, NOMCIU)
    SELECT DISTINCT PAITOR, CIUTOR
    FROM IMPBD.TORERO
    -- Comprobación de que no esté insertado en DEFBD
    WHERE (PAITOR, CIUTOR) NOT IN (
        SELECT NOMPAI, NOMCIU
        FROM DEFBD.UBICACION
    );

-- Insert en ubicación desde apoderat
INSERT INTO UBICACION (NOMPAI, NOMCIU)
    SELECT DISTINCT PAIAPO, CIUAPO
    FROM IMPBD.APODERAT
    -- Comprobación de que no esté insertado en DEFBD
    WHERE (PAIAPO, CIUAPO) NOT IN (
        SELECT NOMPAI, NOMCIU
        FROM DEFBD.UBICACION
    );

-- Comprobación de si hay duplicidades
SELECT NOMPAI, NOMCIU, COUNT(*) AS QTT
FROM UBICACION
GROUP BY NOMPAI, NOMCIU
HAVING COUNT(*) > 1;
-- Debería salir Empty Set (conjunto vacío)

-- Comprobación de si la cantidad es correcta
SELECT COUNT(*) FROM (
    SELECT DISTINCT CIUTOR, PAITOR FROM TORERO
        UNION
        SELECT DISTINCT CIUAPO, PAIAPO FROM APODERAT
            UNION
            SELECT DISTINCT CIUPLA, PAIPLA FROM PLAZA
) AS DIFFERENT_LOCATIONS;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM UBICACION;

-- ===================================================================================
-- TABLA PERSONA
-- Insert en Persona desde Torero
INSERT INTO PERSONA (ideper, ideubi, nompe, co1pe, co2pe, maiper, dirper)
    SELECT IDETOR, UBI.ideubi, NOMTOR, CO1TOR, CO2TOR, MAITOR, DIRTOR
    FROM IMPBD.TORERO TOR
        JOIN DEFBD.UBICACION UBI
        ON UBI.NOMPAI = TOR.PAITOR
        AND UBI.NOMCIU = TOR.CIUTOR
    -- Comprobación de que no esté insertado en DEFBD
    WHERE TOR.IDETOR NOT IN (
        SELECT IDEPER FROM PERSONA
    );

-- Insert en Persona desde Apoderat
INSERT INTO PERSONA (ideper, ideubi, nompe, co1pe, co2pe, maiper, dirper)
    SELECT IDEAPO, UBI.ideubi, NOMAPO, CO1APO, CO2APO, MAIAPO, DIRAPO
    FROM IMPBD.APODERAT APO
        JOIN DEFBD.UBICACION UBI
        ON UBI.NOMPAI = APO.PAIAPO
        AND UBI.NOMCIU = APO.CIUAPO
    -- Comprobación de que no esté insertado en DEFBD
    WHERE APO.IDEAPO NOT IN (
        SELECT IDEPER FROM PERSONA
    );

-- Comprobación de si hay duplicidades
SELECT IDEPER, NOMPE, COUNT(*) AS QTT
FROM PERSONA
GROUP BY IDEPER, NOMPE
HAVING COUNT(*) > 1;

-- Comprobación del número de personas únicas (necesarios isnerts previos en torero y apoderat)
SELECT COUNT(DISTINCT ide)
FROM (
    SELECT IDETOR AS ide
    FROM TORERO
    WHERE IDETOR IS NOT NULL
        UNION
        SELECT IDEAPO
        FROM APODERAT
        WHERE IDEAPO IS NOT NULL
) AS DIFFERENT_PERSONS;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM PERSONA;
-- ===================================================================================
-- TABLA APODERAT
INSERT INTO APODERAT (IDEAPO)
    SELECT DISTINCT IDEAPO
    FROM IMPBD.APODERAT;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM APODERAT;
-- ===================================================================================
-- TABLA TORERO
INSERT INTO TORERO (IDETOR, IDEAPO)
    SELECT IDETOR, IDEAPO
    FROM IMPBD.TORERO;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM TORERO;
-- ===================================================================================
-- TABLA PLAZA
INSERT INTO PLAZA (nompla, ideubi, anypla, locpla, tippla, estpla, muspla)
    SELECT NOMPLA, UBI.ideubi, ANYPLA, LOCPLA, TIPPLA, ESTPLA, MUSPLA
    FROM IMPBD.PLAZA PLA
        JOIN UBICACION UBI
        ON UBI.NOMCIU = PLA.CIUPLA
        AND UBI.NOMPAI = PLA.PAIPLA;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM PLAZA;
-- ===================================================================================
-- TABLA ACTUACION
INSERT INTO ACTUACION (idetor, nompla, datcor)
    SELECT TOR.idetor, PLA.nompla, ACT.DATCOR
    FROM IMPBD.ACTUACIO ACT
        JOIN DEFBD.TORERO TOR
        ON TOR.IDETOR = ACT.IDETOR
            JOIN DEFBD.PLAZA PLA
            ON PLA.NOMPLA = ACT.NOMPLA;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM ACTUACION;
-- Comprobación de cantidad de datos en tabla original de IMPBD
SELECT COUNT(*) FROM ACTUACIO;
-- ===================================================================================
-- TABLA ESDEVENIMENT
INSERT INTO ESDEVENIMENT (FIRCOR, NOMPLA, DATCOR)
    SELECT DISTINCT ESD.FIRCOR, PLA.NOMPLA, ESD.DATCOR
    FROM IMPBD.ESDEVENIMENT ESD
        INNER JOIN PLAZA PLA
        ON PLA.NOMPLA = ESD.NOMPLA;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM ESDEVENIMENT;

-- Esdeveniments celebrados el mismo día en plazas distintas
SELECT FIRCOR, DATCOR, COUNT(*) AS QTT
FROM ESDEVENIMENT
GROUP BY FIRCOR, DATCOR
HAVING COUNT(*)>1;

-- Cantidad de esdeveniments diferentes en IMPBD
SELECT COUNT(DISTINCT FIRCOR, DATCOR, NOMPLA) FROM ESDEVENIMENT;
-- Ramaderias en la tabla esdeveniment de IMPBD
SELECT COUNT(DISTINCT CIFRAM) AS QTT FROM ESDEVENIMENT;
-- ===================================================================================
-- TABLA RAMADERIA
INSERT INTO DEFBD.RAMADERIA (CIFRAM, NOMRAM)
    SELECT DISTINCT ESD.CIFRAM, ESD.NOMRAM
    FROM IMPBD.ESDEVENIMENT ESD
    WHERE NOT EXISTS (
        SELECT 1
        FROM RAMADERIA RAM
        WHERE RAM.CIFRAM = ESD.CIFRAM
    );

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM RAMADERIA;
-- ===================================================================================
-- TABLA TORO
INSERT INTO TORO (CIFRAM, NOMBOU, ANYBOU, PESBOU) 
    SELECT DISTINCT ESD.CIFRAM, ESD.NOMBOU, ESD.ANYBOU, ESD.PESBOU
    FROM IMPBD.ESDEVENIMENT ESD
    WHERE (ESD.CIFRAM, ESD.NOMBOU, ESD.ANYBOU) NOT IN (
        SELECT TOR.CIFRAM, TOR.NOMBOU, TOR.ANYBOU
        FROM DEFBD.TORO TOR
    );

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM TORO;
-- Toros distintos en IMPBD
SELECT COUNT(DISTINCT NOMBOU, ANYBOU, PESBOU) AS QTT_TOROS FROM ESDEVENIMENT;
-- ===================================================================================
-- TABLA R_ESDEVENIMENT_TORO
-- Insertar datos en R_ESDEVENIMENT_BOU
INSERT INTO R_ESDEVENIMENT_TORO (idtoro, ideesd)
    SELECT DISTINCT idtoro, ideesd
    FROM DEFBD.TORO TOR
        -- Acceso a esdeveniment de IMPBD
        JOIN IMPBD.ESDEVENIMENT ESD
        ON ESD.NOMBOU = TOR.NOMBOU
        AND ESD.ANYBOU = TOR.ANYBOU
        AND ESD.PESBOU = TOR.PESBOU
        -- Acceso a esdeveniment de DEFBD
        JOIN DEFBD.ESDEVENIMENT E
        ON E.FIRCOR=ESD.FIRCOR
        AND E.NOMPLA=ESD.NOMPLA
        AND E.DATCOR=ESD.DATCOR;
        -- Comprobación de duplicados por seguridad
        -- ON DUPLICATE KEY UPDATE ideesd = VALUES(ideesd), idtoro = VALUES(idtoro);

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM R_ESDEVENIMENT_TORO;
-- Comprobación de cantidades en IMPBD
SELECT COUNT(*) AS QTT_ESD FROM ESDEVENIMENT;
-- ===================================================================================
-- TABLA FERIA
INSERT INTO FERIA (fircor)
    SELECT DISTINCT ESD.fircor
    FROM IMPBD.esdeveniment ESD;

-- Comprobación de cuantas filas hay en la tabla
SELECT COUNT(*) FROM FERIA;
-- Cantidad de ferias distintas en IMPBD
SELECT COUNT(DISTINCT fircor) AS QTT_FERIAS FROM ESDEVENIMENT;
-- ===================================================================================