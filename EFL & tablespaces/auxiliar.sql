-- 1. TAMAÑO BLOQUE
SELECT current_setting('block_size') AS tamano_bloque;

-- 2. REGISTROS POR CADA BLOQUE EN ALIMENT
SELECT (ctid::text::point)[0]::bigint AS numero_bloque, count(*) AS numero_registros
FROM aliment
GROUP BY numero_bloque
ORDER BY numero_bloque;

-- 3. CREAR TABLESPACE tb1
CREATE TABLESPACE tb1 LOCATION 'C:\Users\mvent\OneDrive\Escritorio\Mario\Universidad\4 CARRERA\1 SEMESTRE\SGBD\Practica 2\tablespace';

-- 4. MOVER DATABASE A tb1
ALTER DATABASE practica2 SET TABLESPACE tb1;
\l+ practica2;

-- 5. REGISTROS POR CADA BLOQUE EN ALBARA
SELECT (ctid::text::point)[0]::bigint AS numero_bloque, count(*) AS numero_registros
FROM albara
GROUP BY numero_bloque
ORDER BY numero_bloque;

-- 7. ANALISIS CON 32K DE BLOQUE
    -- 7.1 Para aliment
SELECT (ctid::text::point)[0]::bigint AS numero_bloque, count(*) AS numero_registros
FROM aliment
GROUP BY numero_bloque
ORDER BY numero_bloque;

    -- 7.2 Para albara
SELECT (ctid::text::point)[0]::bigint AS numero_bloque, count(*) AS numero_registros
FROM albara
GROUP BY numero_bloque
ORDER BY numero_bloque;