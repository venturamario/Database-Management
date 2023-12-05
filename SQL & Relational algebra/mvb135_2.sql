/*
2. Adjuntar un fitxer .sql on hi hagui la resolució de la primera pregunta de l'examen.
*/

SELECT ALI.referencia, ALI.nom
FROM Aliment ALI
    JOIN Linia_ALbara LA
    ON LA.referencia = ALI.referencia
        JOIN Albara ALB
        ON ALB.codi = LA.codi_alb
            JOIN proveidor PRO
            ON PRO.nif = ALB.nif_pro
            AND PRO.nom = 'UIBFruita'
ORDER BY ALI.referencia ASC;