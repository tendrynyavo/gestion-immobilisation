CREATE OR REPLACE VIEW v_initialisation_mere AS
SELECT *
FROM IMMOBILISATION.COMPOSANT, IMMOBILISATION.BIEN;

CREATE OR REPLACE VIEW v_last_inventaire AS
SELECT i.code, MAX(i.DATE_INVENTAIRE) AS dernier_inventaire
FROM ETAT_COMPOSANT ec
JOIN inventaire i ON i.id_inventaire = ec.id_inventaire
GROUP BY i.code;

CREATE OR REPLACE VIEW v_last_inventaire_etat AS
SELECT id_composant, i.code, etat, i.DATE_INVENTAIRE, i.id_inventaire
FROM ETAT_COMPOSANT e
JOIN inventaire i ON i.id_inventaire = e.id_inventaire
JOIN v_last_inventaire l ON l.code = i.code AND l.DERNIER_INVENTAIRE = i.DATE_INVENTAIRE;

CREATE OR REPLACE VIEW v_etat AS
SELECT *
FROM V_INITIALISATION_MERE
UNION
SELECT id_composant, i.code, etat
FROM v_last_inventaire_etat e
JOIN inventaire i ON i.id_inventaire = e.id_inventaire;

CREATE OR REPLACE VIEW v_etat_finale AS
SELECT ID_COMPOSANT, CODE, MAX(ETAT) AS ETAT
FROM V_ETAT 
GROUP BY ID_COMPOSANT, CODE;

CREATE OR REPLACE VIEW v_etat_composant AS
SELECT c.ID_COMPOSANT, nom, mere, code , etat
FROM V_ETAT_FINALE e
JOIN COMPOSANT c ON c.ID_COMPOSANT = e.id_composant;

CREATE OR REPLACE VIEW v_hierachie AS
SELECT id_composant, nom, CONNECT_BY_ROOT nom AS manager, code, mere, ETAT, LEVEL AS niveau
FROM V_ETAT_COMPOSANT
START WITH mere IS NULL
CONNECT BY PRIOR ID_COMPOSANT = MERE

CREATE OR REPLACE VIEW V_COMPOSANT AS
SELECT id_composant, nom, manager, code, mere, niveau, max(etat) AS etat
FROM V_HIERACHIE i
GROUP BY id_composant, nom, Manager, code, mere, niveau;

CREATE OR REPLACE VIEW v_hierachie_simple AS
SELECT id_composant, nom, CONNECT_BY_ROOT id_composant AS manager, code, mere, ETAT, LEVEL AS niveau
FROM IMMOBILISATION.V_ETAT_COMPOSANT
CONNECT BY PRIOR ID_COMPOSANT = MERE

CREATE OR REPLACE VIEW v_composant_etat AS
SELECT id_composant, nom, manager, code, mere, niveau, max(etat) AS etat
FROM IMMOBILISATION.v_hierachie_simple i
GROUP BY id_composant, nom, Manager, code, mere, niveau;

CREATE OR REPLACE VIEW v_etat_composant_hierarchie AS
SELECT manager AS ID_COMPOSANT, code, sum(etat) / greatest((count(*) - 1), 1) AS etat, greatest((count(*) - 1), 1) AS nombre
FROM IMMOBILISATION.V_COMPOSANT_ETAT
GROUP BY manager, code;

CREATE OR REPLACE VIEW v_composant_etat_hierarchie AS
SELECT c.ID_COMPOSANT , nom, ROUND(etat, 2) AS etat, e.code, mere, nombre, c.id_immobilisation, c.capacite, c.unite, c.alerte, co.designation AS comportement, co.color, co.debut, co.fin
FROM IMMOBILISATION.v_etat_composant_hierarchie e
JOIN IMMOBILISATION.COMPOSANT c ON c.ID_COMPOSANT = e.id_composant
JOIN IMMOBILISATION.RECEPTION r ON r.code = e.code
JOIN COMPORTEMENT co ON co.debut <= etat AND etat <= co.fin
WHERE r.ID_IMMOBILISATION = c.ID_IMMOBILISATION;

CREATE OR REPLACE VIEW v_bien AS
SELECT b.code, nom, ID_MARQUE, date_reception, id_addresse, id_immobilisation 
FROM BIEN b 
JOIN RECEPTION r ON b.code = r.code;

CREATE OR REPLACE VIEW v_alerte AS
SELECT *
FROM V_COMPOSANT_ETAT_HIERARCHIE
WHERE etat <= alerte;

CREATE OR REPLACE VIEW v_etat_bien AS
SELECT code, nom, (sum(etat) / COUNT(*)) AS etat, COUNT(*) AS nombre
FROM V_COMPOSANT_ETAT_HIERARCHIE
WHERE mere IS NULL
GROUP BY code, nom, id_marque;

CREATE OR REPLACE VIEW V_ALERTE_NOMBRE AS 
SELECT 
	b.code, SUM(
	CASE 
		WHEN a.code IS NULL THEN 0
		ELSE 1
	END) AS alerte
FROM V_ALERTE a
RIGHT JOIN bien b ON a.code = b.code
GROUP BY b.code;

CREATE OR REPLACE VIEW v_liste_bien_etat AS
SELECT e.code, b.id_marque, b.nom, e.etat, co.DESIGNATION AS COMPORTEMENT, co.color, a.alerte, r.DATE_RECEPTION, r.ID_ADDRESSE, r.ID_IMMOBILISATION
FROM v_etat_bien e
JOIN COMPORTEMENT co ON etat BETWEEN co.debut AND co.fin
JOIN RECEPTION r ON r.code = e.code
JOIN BIEN b ON b.code = e.code
JOIN V_ALERTE_NOMBRE a ON a.code = e.code;

CREATE OR REPLACE VIEW v_niveau AS
SELECT CONNECT_BY_ROOT id_composant AS id_composant, LEVEL AS niveau
FROM COMPOSANT
CONNECT BY PRIOR ID_COMPOSANT = MERE;

CREATE OR REPLACE VIEW v_niveau_max AS
SELECT id_composant, MAX(Niveau) AS niveau
FROM v_niveau
GROUP BY id_composant;

CREATE OR REPLACE VIEW v_composant_inventaire AS
SELECT COALESCE(co.ID_COMPOSANT, 'ID') AS mere_id_composant, COALESCE(co.NOM, 'Composant Indépandent') AS mere_nom, co.ALERTE as mere_alerte, c.ID_COMPOSANT, c.NOM, c.ID_IMMOBILISATION, c.CAPACITE, c.UNITE, c.ALERTE
FROM v_niveau_max n
JOIN composant c ON n.id_composant = c.ID_COMPOSANT
LEFT JOIN COMPOSANT co ON co.ID_COMPOSANT  = c.Mere
WHERE niveau = 1
ORDER BY mere_id_composant, ID_COMPOSANT;

SELECT debut - fin
FROM v_mission;