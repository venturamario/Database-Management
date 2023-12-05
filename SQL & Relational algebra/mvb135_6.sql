/*
6. Adjuntar un fitxer .sql on hi hagui la resolució de la quinta pregunta de l'examen.
*/

/*
Se puede hacer esta consulta facilmente si establecemos un límite <1. Haremos esto con la condición HAVING
de la clausula GROUP BY
*/
SELECT VEN.codi, COUNT(*) AS NUM_COD
FROM Venda VEN
GROUP BY VEN.codi
HAVING COUNT(*) > 1;