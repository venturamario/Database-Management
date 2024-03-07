-- ===================================================================================
-- ====================== Mario Ventura Burgos - 43223476J ===========================
-- ================= Sistemas de gestión de base de datos ============================
-- ======= Consultas para comprobar multipliocidades de los dicheros de datos ========
-- ===================================================================================

-- COMPROBACIÓN DE SI UN TORERO TIENE UN ÚNICO APODERADO
-- Se seleccionan los toreros con mas de 1 apoderado
SELECT IDEAPO AS ID, COUNT(IDETOR) AS QTT_APODERADO
FROM TORERO
WHERE IDEAPO IS NULL
GROUP BY ID HAVING COUNT(ID) > 1;

-- COMPROBACIÓN DE SI EXISTEN TOREROS SIN APODERADO
-- Se seleccionan los toreros sin apoderado
SELECT IDETOR AS ID FROM TORERO WHERE IDEAPO IS NULL;

-- =====================================================================

-- COMPROBACIÓN DE MULTIPLICIDAD 0..* DE TORERO CON ACTUACIO
-- Se seleccionan los toreros que no tienen actuación asociada
SELECT COUNT(*) FROM TORERO WHERE IDETOR NOT IN (
    SELECT DISTINCT IDETOR AS ID_TORERO
    FROM ACTUACIO
);

-- =====================================================================

-- COMPROBACIÓN DEL NÚMERO DE APARICIONES DE LAS FERIAS QUE MÁS APARECEN
-- EN LA TABLA ESDEVENIMENT. COMPROBAMOS REDUNDANCIAS CON CLÁUSULA HAVING
-- Selección de las 10 ferias con más apariciones en esdeveniment
SELECT FIRCOR AS NOMBRE_FERIA, COUNT(*) AS NUM_APARICIONES
FROM ESDEVENIMENT
GROUP BY FIRCOR HAVING COUNT(*) > 1
ORDER BY NUM_APARICIONES DESC
LIMIT 10;

-- =====================================================================
-- COMPROBACIÓN DE SI EN UNA PLAZA SE PUEDEN haber CERO O VARIOS ESDEVENIMENTS
-- Selección de plazas con más de 1 esdeveniment, limitado a 10 plazas
-- máximo y orden de resultado de mayor a menor
SELECT PLAZA.NOMPLA AS NOMBRE, COUNT(DISTINCT ESDEVENIMENT.FIRCOR) AS NUM_ESD
FROM PLAZA
    LEFT JOIN ESDEVENIMENT
    ON ESDEVENIMENT.NOMPLA = PLAZA.NOMPLA
GROUP BY PLAZA.NOMPLA HAVING COUNT(ESDEVENIMENT.FIRCOR) > 1
ORDER BY NUM_ESD DESC
LIMIT 10;

-- Selección de esdeveniments con 0 plazas asociadas
SELECT PLAZA.NOMPLA FROM PLAZA
    LEFT JOIN ESDEVENIMENT
    ON PLAZA.NOMPLA = ESDEVENIMENT.NOMPLA
WHERE ESDEVENIMENT.NOMPLA IS NULL
LIMIT 10;

-- =====================================================================