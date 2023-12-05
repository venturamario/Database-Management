/*
3. Adjuntar un fitxer .sql on hi hagui la resolució de la segona pregunta de l'examen.
*/

SELECT ALB.codi, PRO.nom
FROM Albara ALB
    JOIN Proveidor PRO
    ON PRO.nif = ALB.nif_pro    /*Hay que entrar en la tabla ya que se quiere algo de ella*/
        JOIN Linia_ALbara LA
        ON LA.codi_alb = ALB.codi
        AND LA.preu IS NULL     /*Sin especificar precio = columna precio con valor NULL*/
WHERE ALB.facturat = 'S';       /*Facturados = columna facturat con valor 'S'*/