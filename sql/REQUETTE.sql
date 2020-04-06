\echo  'Les requettes demandées'

-------------------------------------------------
\echo 'Difficulté 1'
-------------------------------------------------

-------------------------------------------------
\echo 'Question 1'
-------------------------------------------------

\echo 'les athlètes italiens ayant obtenu une médailles'

SELECT * FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
WHERE ( ( resAth.RANG<4 )  AND  ( ath.PAYS='Italy' ) );


-------------------------------------------------
\echo 'Question 2'
-------------------------------------------------
\echo 'les médaillés du 100m, 200m, et 400m'

SELECT ath.nom,ath.pays,subEp.DETAIL FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth ,SUB_EPREUVES AS subEp
WHERE( resAth.RANG<4 AND subEp.ID=resAth.ID_SUB_EPREUVE AND resAth.ID_SUB_EPREUVE IN
  (SELECT ID FROM SUB_EPREUVES WHERE ( DETAIL IN ('100M M','100M F', '200M M','200M F', '400M M','400M F') ) )
     )
ORDER BY (subEp.DETAIL);




-------------------------------------------------
\echo 'Question 3'
-------------------------------------------------

\echo 'Les membres de l equipe féminine de handball de moins de 25 ans'

SELECT ath.nom,ath.prenom,ath.sexe,ath.pays,EXTRACT(YEAR FROM age(ath.DATE_NAISSANCE) )AS AGE
FROM ATHLETES AS ath
NATURAL JOIN MEMBRES AS m
NATURAL JOIN  RESULTATS_EQUIPE AS eqp
WHERE (
  eqp.ID_SUB_EPREUVE IN
  (SELECT ID FROM SUB_EPREUVES WHERE NOM_EPREUVE='HANDBALL' AND DETAIL='F')
  AND EXTRACT(YEAR FROM age(ath.DATE_NAISSANCE))<=25
);




-------------------------------------------------
\echo 'Question 4'
-------------------------------------------------

SELECT res_ath.RANG,sub.DETAIL,res_ath.DUREE FROM RESULTATS_ATHLETE AS res_ath
JOIN SUB_EPREUVES AS sub ON (res_ath.ID_SUB_EPREUVE=sub.ID)
WHERE ( res_ath.ID_ATHLETE=
  (SELECT DISTINCT ID_ATHLETE FROM ATHLETES
    WHERE NOM='Michael' AND PRENOM='Phelps')
  );
-------------------------------------------------
\echo 'Question 5'
-------------------------------------------------

SELECT NOM_EPREUVE FROM EPREUVES WHERE
(TYPE_EPREUVE='EN EQUIPE');

SELECT DISTINCT NOM_EPREUVE FROM SUB_EPREUVES subEp
JOIN RESULTATS_ATHLETE resAth ON ( subEp.ID = resAth.ID_SUB_EPREUVE )
NATURAL JOIN ATHLETES ath
WHERE ath.STATUS = 1;

-------------------------------------------------
\echo 'Question 6'
-------------------------------------------------

------------ Meilleur temps réalisé au marathon

SELECT MIN(resAth.DUREE) AS RECORD FROM  RESULTATS_ATHLETE AS resAth JOIN SUB_EPREUVES AS subEp
    ON( resAth.ID_SUB_EPREUVE = subEp.ID )
    WHERE
     (subEp.id IN ( SELECT ID FROM SUB_EPREUVES WHERE DETAIL = 'MARATHON M' ))
    ;



------------------------------------------------------------------------------------------------------------
-------------------------------------------------
\echo 'Difficulté 2'
-------------------------------------------------

------------------ QUESTION 01 ------------------
SELECT ath.PAYS,AVG(resAth.DUREE) FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
JOIN SUB_EPREUVES AS subEp
ON (resAth.ID_SUB_EPREUVE=subEp.ID)
WHERE (subEp.DETAIL LIKE '200M_NAGE_LIBRE%') GROUP BY (ath.PAYS);

-------------------------------------------------



------------------ QUESTION 02 ------------------
------ creer une vue avec nombre de médailles gagnée par chaque pays dans les sports individuels ------
CREATE MATERIALIZED VIEW nb_md1 AS
SELECT ath.PAYS AS PAYS,COUNT(*) AS md_ath
FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
JOIN SUB_EPREUVES AS subEpON (resAth.ID_SUB_EPREUVE=subEp.ID)
WHERE ( resAth.RANG < 4 AND ath.STATUS = 0)
GROUP BY ath.PAYS;

------ creer une vue avec nombre de médailles gagnée par chaque pays dans les sports en équipes ------
CREATE MATERIALIZED VIEW nb_md2 AS
SELECT Eq.PAYS AS PAYS,COUNT(DISTINCT resEq.ID_EQUIPE) AS md_eq
FROM RESULTATS_EQUIPE AS resEq,EQUIPES AS Eq
WHERE ( resEq.RANG < 4 AND Eq.ID_EQUIPE=resEq.ID_EQUIPE)
GROUP BY Eq.PAYS;

---- Le nombre de médailles gagnées par pays ----
WITH tmp AS(
SELECT pays,md_ath as nbMedailles FROM nb_md1
UNION
SELECT pays,md_eq as nbMedailles FROM nb_md2)
SELECT pays,SUM(nbMedailles) FROM tmp
GROUP BY pays
ORDER BY pays;

-------------------------------------------------


------------------ QUESTION 03 ------------------
SELECT subEp.NOM_EPREUVE,subEp.DETAIL,ath.NOM,ath.PAYS,resAth.RANG
FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
JOIN SUB_EPREUVES AS subEp
ON (resAth.ID_SUB_EPREUVE=subEp.ID) WHERE (resAth.RANG<3)
ORDER BY subEp.ID ASC;

-------------------------------------------------

------------------ QUESTION 04 ------------------
SELECT * FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
WHERE (resAth.RANG>1 AND 4>resAth.RANG);

-------------------------------------------------


------------------ QUESTION 05 ------------------
SELECT ath.ID_ATHLETE,ath.NOM,ath.PRENOM,subEp.DETAIL FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
JOIN SUB_EPREUVES AS subEp
ON (resAth.ID_SUB_EPREUVE=subEp.ID)
NATURAL JOIN EPREUVES AS ep
WHERE ( ath.PAYS='France' AND resAth.RANG=4 AND ep.TYPE_EPREUVE='INDIVIDUELLE' );

-------------------------------------------------

------------------ QUESTION 06 ------------------
SELECT ath.NOM,ath.PRENOM,ath.SEXE,ath.PAYS,resAth.DUREE FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
JOIN SUB_EPREUVES AS subEp ON (resAth.ID_SUB_EPREUVE=subEp.ID)
WHERE (subEp.DETAIL LIKE '100M %' AND resAth.DUREE<=10);

-------------------------------------------------

-------------------------------------------------
\echo 'Difficulté 3'
-------------------------------------------------

------------------ QUESTION 02 ------------------
SELECT DISTINCT ath.PAYS
FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
JOIN SUB_EPREUVES AS subEp
ON (resAth.ID_SUB_EPREUVE=subEp.ID) WHERE (resAth.RANG<4) ;


------------------ QUESTION 03 ------------------
SELECT subEp.NOM_EPREUVE AS CATEGORIE ,COUNT(subEp.DETAIL) AS EPREUVES
FROM SUB_EPREUVES AS subEp
GROUP BY (subEp.NOM_EPREUVE )
ORDER BY EPREUVES ASC LIMIT 5;


-------------------- QUESTION 04 ----------------------

--------------------- Le nombre des femmes médaillées ---------------------------
SELECT COUNT(*) FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
WHERE ( ath.SEXE='F' AND resAth.RANG < 4 );

--------------------- Le nombre  total des femmes  ---------------------------

SELECT COUNT(*) FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
WHERE ( ath.SEXE='F' );

--------------------- Le Pourcentage des femmes médaillées ---------------------------

SELECT 100.0*COUNT(*)/(SELECT COUNT(*) FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
WHERE ( ath.SEXE='F' ) ) AS POURCENTAGE_DES_FEMMES_MEDAILLEES FROM ATHLETES AS ath
NATURAL JOIN RESULTATS_ATHLETE AS resAth
WHERE ( ath.SEXE='F' AND resAth.RANG < 4 );

---------------------------------------------------------------------------------------


--------------------- QUESTION 06 ---------------------------

CREATE MATERIALIZED VIEW tabSansfrance AS
SELECT subEp.NOM_EPREUVE, ath.PAYS, count(*) as nbMedailles
FROM RESULTATS_ATHLETE resAth, ATHLETES ath, SUB_EPREUVES subEp
WHERE resAth.ID_ATHLETE = ath.ID_ATHLETE AND resAth.RANG<4 AND resAth.ID_SUB_EPREUVE = subEp.ID AND ath.PAYS NOT LIKE 'France'
GROUP BY subEp.NOM_EPREUVE, ath.PAYS
ORDER BY subEp.NOM_EPREUVE ASC;

CREATE MATERIALIZED VIEW tabfrance AS
SELECT subEp.NOM_EPREUVE, ath.PAYS, count(*) as nbMedailles
FROM RESULTATS_ATHLETE resAth, ATHLETES ath, SUB_EPREUVES subEp
WHERE resAth.ID_ATHLETE = ath.ID_ATHLETE AND resAth.RANG<4 AND resAth.ID_SUB_EPREUVE = subEp.ID AND ath.PAYS LIKE 'France'
GROUP BY subEp.NOM_EPREUVE, ath.PAYS
ORDER BY subEp.NOM_EPREUVE ASC;

(SELECT p1.PAYS, p1.NOM_EPREUVE, p1.nbMedailles
FROM tabSansfrance p1, tabfrance p2
WHERE p1.NOM_EPREUVE = p2.NOM_EPREUVE
AND p1.nbMedailles > p2.nbMedailles)
UNION
(SELECT p1.PAYS, p1.NOM_EPREUVE, p1.nbMedailles
FROM tabSansfrance p1, tabfrance p2
WHERE p1.NOM_EPREUVE <> p2.NOM_EPREUVE)
ORDER BY NOM_EPREUVE ASC;



--------------------------------------------------------------
------------------- Requettes supplémentaires ----------------
--------------------------------------------------------------

----------------- 1 ------------------------------------------
-- Les athletes qui ont obtenus au moins une médaille dans
--  deux épreuves différentes (Deux sous Epreuves Différentes)

SELECT DISTINCT A.ID_ATHLETE, NOM, PRENOM, R.RANG
FROM ATHLETES A, RESULTATS_ATHLETE R, SUB_EPREUVES E1
WHERE ( R.ID_ATHLETE=A.ID_ATHLETE AND R.ID_SUB_EPREUVE=E1.ID AND R.RANG < 4
AND EXISTS
          (SELECT * FROM RESULTATS_ATHLETE R2 , SUB_EPREUVES E2 , ATHLETES A2
              WHERE (
              E1.ID <> E2.ID
              AND R2.RANG < 4
              AND R2.ID_ATHLETE=A2.ID_ATHLETE
              AND R2.ID_SUB_EPREUVE=E2.ID
              AND A2.ID_ATHLETE=A.ID_ATHLETE ) ) )
ORDER BY A.ID_ATHLETE;

--------------------------------------------------------------

----------------- 2 ------------------------------------------
-- Le Pays Qui a obtenu le plus de medailles que tout
--  les autres classés par type de médaille

SELECT A1.PAYS,R1.RANG FROM ATHLETES A1
NATURAL JOIN RESULTATS_ATHLETE R1
WHERE A1.STATUS=0  AND R1.RANG < 4
AND EXISTS
  ( SELECT * FROM ATHLETES A2
    NATURAL JOIN RESULTATS_ATHLETE R2
    WHERE ( A2.STATUS=0  AND R2.RANG < 4 AND A1.PAYS <> A2.PAYS ) )
GROUP BY A1.PAYS,R1.RANG
HAVING
( COUNT(*) >= ALL ( SELECT COUNT(*) FROM ATHLETES A2
  NATURAL JOIN RESULTATS_ATHLETE R2
  WHERE A2.STATUS=0  AND R2.RANG < 4
  GROUP BY A2.PAYS,R2.RANG ));


--------------------------------------------------------------

----------------- 3 ------------------------------------------

-- Le pays qui a obtenu au Au moins 2 % Des medailles du Jeux
--                                                   Olympiques

WITH tmp AS(
SELECT pays,md_ath as nbMedailles FROM nb_md1
UNION
SELECT pays,md_eq as nbMedailles FROM nb_md2)
SELECT pays,SUM(nbMedailles) FROM tmp
GROUP BY pays
HAVING ( SUM(nbMedailles) >= (SELECT 0.02*SUM(nbMedailles) FROM tmp))
ORDER BY pays;
--------------------------------------------------------------







SELECT ev.ENDROIT , subEp.NOM_EPREUVE , ev.DATE_ , count(resAth.ID_ATHLETE) AS indice
FROM EVENEMENT ev
NATURAL JOIN RESULTATS_ATHLETE resAth
JOIN SUB_EPREUVES subEp ON ( subEp.ID = resAth.ID_SUB_EPREUVE )
GROUP BY ev.ENDROIT, subEp.NOM_EPREUVE , ev.DATE_, indice
ORDER BY indice ASC
LIMIT 10;

SELECT ev.ENDROIT , subEp.NOM_EPREUVE , ev.DATE_ , count(resAth.ID_ATHLETE) AS indice
FROM EVENEMENT ev
NATURAL JOIN RESULTATS_ATHLETE resAth
JOIN SUB_EPREUVES subEp ON ( subEp.ID = resAth.ID_SUB_EPREUVE )
GROUP BY ev.ENDROIT, subEp.NOM_EPREUVE , ev.DATE_, indice
ORDER BY indice DESC
LIMIT 10;

--------------------------------------------------------------
