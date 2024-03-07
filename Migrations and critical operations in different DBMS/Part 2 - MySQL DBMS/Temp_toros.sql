-- ===================================================================================
-- ====================== Mario Ventura Burgos - 43223476J ===========================
-- ================= Sistemas de gestión de base de datos ============================
-- ========== Código usado para la creación de una bd de toros de prueba =============
-- ===================================================================================

-- CREACIÓN DE BD DE PRUEBA
CREATE DATABASE TOROS_PRUEBA
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

-- ACCESO A LA BD
USE TOROS_PRUEBA;

-- TABLA DE TORO (ADAPTADA SIN FK'S)
CREATE TABLE TORO (
    idtoro INT(11) AUTO_INCREMENT, -- Identificador del toro (autoincremental)
    cifram VARCHAR(3) NOT NULL,     -- Clave forana que referencia a RAMADERIA(cifram)
    nombou VARCHAR(50) NOT NULL,    -- Nombre o identificación del toro
    anybou DATE NOT NULL,           -- Año de nacimiento del toro
    pesbou DECIMAL(10,2) NOT NULL,  -- Peso del toro
    CONSTRAINT PK_TORO PRIMARY KEY (idtoro)
);

-- INSERTS DE EJEMPLO
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('ABC', 'Toro1', '2020-01-01', 800.50);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('DEF', 'Toro2', '2019-02-15', 750.25);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('GHI', 'Toro3', '2022-05-20', 900.75);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('JKL', 'Toro4', '2021-12-10', 820.00);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('MNO', 'Toro5', '2020-08-03', 880.30);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('PQR', 'Toro6', '2019-11-25', 720.80);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('STU', 'Toro7', '2022-03-15', 950.00);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('VWX', 'Toro8', '2021-07-08', 870.60);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('YZA', 'Toro9', '2020-09-30', 810.40);
INSERT INTO TORO (cifram, nombou, anybou, pesbou) VALUES ('BCD', 'Toro10', '2019-04-12', 760.90);

-- ACTUALIZACIÓN DE TOROS MEDIANTE PLANTEAMIENTO
-- PLANTEAMIENTO: INTERVALO 2 AÑOS + INTERVALO 6 MONTHS
UPDATE TORO TOR
SET ANYBOU = DATE_SUB(TOR.ANYBOU, INTERVAL 2 YEAR) - INTERVAL 6 MONTH;