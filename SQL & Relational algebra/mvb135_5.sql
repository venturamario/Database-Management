/*
5. Adjuntar un fitxer .sql on hi hagui la resolució de la quarta pregunta de l'examen.
*/

/*
Creamos una vista donde se vea, para cada venta, la referencia del producto vendido y los kg vendidos
*/
CREATE VIEW QUILOSVENDA AS
    SELECT VEN.referencia, SUM(VEN.quilograms) AS KG_VENUTS
    FROM Venda VEN
    GROUP BY VEN.referencia;

/*
Creamos una vista donde se vea, para cada producto en el albaran, la referencia del producto vendido y los kg
*/
CREATE VIEW QUILOSALBARA AS
    SELECT LA.referencia, SUM(LA.quilograms) AS KG
    FROM linia_albara LA
    GROUP BY LA.referencia;

/*
Mediante una consulta, restamos los kg de producto - los kg vendidos y se obtiene lo que queda. Esto se hace con
la resta de los quilos de linea_albara - quilos vendidos. Estas dos cantidades son las que se obtienen con las vistas
Esto lo haremos con la ayuda de la funcion COALESCE de sql:
Coalesce returns the first non-null value in a list. If all the values in the list are NULL, then the function returns null. 
*/
SELECT ALI.referencia, ALI.nom, (COALESCE(QUILOSA.KG, 0) - COALESCE(QUILOSV.KG_VENUTS, 0)) AS STOCK
FROM Aliment ALI
    LEFT JOIN QUILOSALBARA QUILOSA
    ON QUILOSA.referencia = ALI.referencia
        LEFT JOIN QUILOSVENDA QUILOSV
        ON QUILOSV.referencia = ALI.referencia;
        -- ORDER BY ... (se puede añadir algun criterio que haga el resultado más legible)