/*
3. Adjuntar un fitxer .sql on hi hagui la resolució de la tercera pregunta de l'examen.
*/
SELECT ALI.referencia, LA.preu
FROM Aliment ALI
    JOIN linia_albara LA
    ON LA.referencia = ALI.referencia
        JOIN Albara ALB
        ON ALB.codi = LA.codi_alb
WHERE ALB.data = (
        SELECT MAX(A.data)
        FROM ALBARA A
            JOIN linia_albara LINALB
            ON LINALB.codi_alb = A.codi
        WHERE LINALB.referencia = LA.referencia
    )
AND LA.preu IS NOT NULL
ORDER BY ALI.referencia; -- No se pide explícitamente pero el resultado será más legible