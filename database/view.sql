CREATE OR REPLACE VIEW v_initialisation_mere AS
SELECT *
FROM IMMOBILISATION.COMPOSANT, IMMOBILISATION.BIEN;

CREATE OR REPLACE VIEW v_etat_inventaire_mission AS
SELECT i.code, ec.id_composant, i.DATE_INVENTAIRE AS dernier_inventaire, ec.etat
FROM ETAT_COMPOSANT ec
	JOIN inventaire i ON i.id_inventaire = ec.id_inventaire
UNION
SELECT code, id_composant, DATE_ACTUELLE, etat
FROM V_ETAT_MISSION_EN_COURS;


CREATE OR REPLACE VIEW v_last_inventaire AS
SELECT code, id_composant, MAX(dernier_inventaire) AS dernier_inventaire
FROM v_etat_inventaire_mission
WHERE dernier_inventaire <= sysdate
GROUP BY code, id_composant;

CREATE OR REPLACE VIEW v_last_inventaire_etat AS
SELECT e.id_composant, e.code, etat, l.dernier_inventaire
FROM v_etat_inventaire_mission e
	JOIN v_last_inventaire l ON l.code = e.code AND l.id_composant = e.id_composant AND l.DERNIER_INVENTAIRE = e.dernier_inventaire;

CREATE OR REPLACE VIEW v_etat AS
SELECT i.*, NULL AS DATE_INVENTAIRE
FROM V_INITIALISATION_MERE i
UNION
SELECT id_composant, code, etat, dernier_inventaire
FROM v_last_inventaire_etat e;

CREATE OR REPLACE VIEW v_etat_finale AS
SELECT ID_COMPOSANT, CODE, MAX(ETAT) AS ETAT, MAX(DATE_INVENTAIRE) AS DATE_INVENTAIRE
FROM V_ETAT 
GROUP BY ID_COMPOSANT, CODE;

CREATE OR REPLACE VIEW v_etat_composant AS
SELECT c.ID_COMPOSANT, nom, mere, code , etat, DATE_INVENTAIRE
FROM V_ETAT_FINALE e
JOIN COMPOSANT c ON c.ID_COMPOSANT = e.id_composant;

CREATE OR REPLACE VIEW v_hierachie AS
SELECT id_composant, nom, CONNECT_BY_ROOT nom AS manager, code, mere, ETAT, LEVEL AS niveau, DATE_INVENTAIRE
FROM V_ETAT_COMPOSANT
START WITH mere IS NULL
CONNECT BY PRIOR ID_COMPOSANT = MERE

CREATE OR REPLACE VIEW V_COMPOSANT AS
SELECT id_composant, nom, manager, code, mere, niveau, max(etat) AS etat, DATE_INVENTAIRE
FROM V_HIERACHIE i
GROUP BY id_composant, nom, Manager, code, mere, niveau, DATE_INVENTAIRE;

CREATE OR REPLACE VIEW v_hierachie_simple AS
SELECT id_composant, nom, CONNECT_BY_ROOT id_composant AS manager, code, mere, ETAT, LEVEL AS niveau, DATE_INVENTAIRE
FROM IMMOBILISATION.V_ETAT_COMPOSANT
CONNECT BY PRIOR ID_COMPOSANT = MERE

CREATE OR REPLACE VIEW v_composant_etat AS
SELECT id_composant, nom, manager, code, mere, niveau, max(etat) AS etat, DATE_INVENTAIRE
FROM IMMOBILISATION.v_hierachie_simple i
GROUP BY id_composant, nom, Manager, code, mere, niveau, DATE_INVENTAIRE;

CREATE OR REPLACE VIEW v_etat_composant_hierarchie AS
SELECT manager AS ID_COMPOSANT, code, sum(etat) / greatest((count(*) - 1), 1) AS etat, greatest((count(*) - 1), 1) AS nombre, MAX(DATE_INVENTAIRE) AS DATE_INVENTAIRE
FROM IMMOBILISATION.V_COMPOSANT_ETAT
GROUP BY manager, code;

CREATE OR REPLACE VIEW v_composant_etat_hierarchie AS
SELECT c.ID_COMPOSANT , nom, ROUND(etat, 2) AS etat, e.code, mere, nombre, c.id_immobilisation, c.capacite, c.unite, c.alerte, co.designation AS comportement, co.color, co.debut, co.fin, DATE_INVENTAIRE
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

CREATE OR REPLACE VIEW v_mission AS
SELECT m.*, f.FIN AS fin, v.ID_VALIDATION, f.ID_INVENTAIRE AS inventaire
FROM mission m
LEFT JOIN valide_mission v ON m.id_mission = v.id_mission
LEFT JOIN fin_mission f ON f.id_mission = m.id_mission;

-- View pour prendre le temps efféctué d'un mission
CREATE OR REPLACE VIEW v_mission_time_seconde AS
SELECT m.*,
		EXTRACT (DAY FROM fin - debut) * 24 * 60 * 60


       + EXTRACT (HOUR FROM fin - debut) * 60 * 60


       + EXTRACT (MINUTE FROM fin - debut) * 60 AS seconds
FROM v_mission m;

-- View pour avoir les listes des missions en cours
CREATE OR REPLACE VIEW v_mission_en_cours AS
SELECT *
FROM v_mission_time_seconde WHERE etat = 10 AND fin is NULL AND debut <= sysdate;


CREATE OR REPLACE VIEW v_etat_mission_validation AS
SELECT ID_COMPOSANT, etat, date_validation, id_mission, v.ID_VALIDATION 
FROM ETAT_INVENTAIRE e
	JOIN VALIDE_MISSION v ON v.ID_VALIDATION  = e.ID_VALIDATION; 

CREATE OR REPLACE VIEW v_etat_composant_mission AS
SELECT m.ID_MISSION, m.code, e.ID_COMPOSANT, m.debut, m.ID_EMPLOYEE, m.SECONDS, e.etat AS reste, ei.etat AS actuelle, (ei.etat - e.etat) AS consommation, extract(month from debut) AS month
FROM v_mission_time_seconde m
JOIN INVENTAIRE i ON i.ID_INVENTAIRE = m.INVENTAIRE
JOIN ETAT_COMPOSANT e ON e.ID_INVENTAIRE = i.ID_INVENTAIRE
JOIN v_etat_mission_validation ei ON ei.id_composant = e.id_composant AND ei.id_mission = m.id_mission;

SELECT 
	x, AVG(x) OVER() AS x_bar, y, AVG(y) OVER() AS y_bar 
FROM SAMPLE s;

SELECT slope,
	y_bar_max - x_bar_max * slope AS intercept
FROM 
	(
		SELECT 
			SUM((x - x_bar) * (y - y_bar)) / SUM((x - x_bar) * (x - x_bar)) AS slope,
			MAX(x_bar) AS x_bar_max,
			MAX(y_bar) AS y_bar_max
		FROM (
			SELECT 
				x, AVG(x) OVER() AS x_bar, y, AVG(y) OVER() AS y_bar 
			FROM SAMPLE s
		)
	);

CREATE OR REPLACE VIEW v_axe_y AS
SELECT code, id_composant, id_employee, AVG(CONSOMMATION) AS consommation
FROM V_ETAT_COMPOSANT_MISSION
GROUP BY code, id_composant, id_employee;
	
CREATE OR REPLACE VIEW v_axe AS
SELECT v.*, SECONDS / 3600 AS x, AVG(SECONDS / 3600) OVER() AS x_bar, CONSOMMATION AS y , AVG(CONSOMMATION) OVER() AS y_bar
FROM V_ETAT_COMPOSANT_MISSION v
	JOIN 
ORDER BY x;

CREATE OR REPLACE VIEW v_slope AS
SELECT code, id_composant, id_employee,
	SUM((x - x_bar) * (y - y_bar)) / SUM((x - x_bar) * (x - x_bar)) AS slope,
	MAX(x_bar) AS x_bar_max,
	MAX(y_bar) AS y_bar_max
FROM V_AXE a
GROUP BY code, id_composant, id_employee;

SELECT code, id_composant, id_employee, x_bar, y_bar
FROM V_AXE a;

CREATE OR REPLACE VIEW v_model AS 
SELECT s.code, s.id_composant, s.id_employee,
	slope,
	consommation - x_bar_max * slope AS intercept 
FROM v_slope s
	JOIN v_axe_y a ON a.code = s.code AND a.id_composant = s.id_composant AND s.id_employee = a.id_employee;

-- FULL INSERT DES ETAT_INVENTAIRE pour chaque composant
CREATE OR REPLACE VIEW v_etat_mission_en_cours AS 
SELECT v.id_composant, m.code, GREATEST(e.etat - (v.slope * ((EXTRACT (DAY FROM CURRENT_TIMESTAMP(1) - debut) * 24 * 60 * 60
       + EXTRACT (HOUR FROM sysdate - debut) * 60 * 60
       + EXTRACT (MINUTE FROM sysdate - debut) * 60) / 3600) + v.intercept) * ((EXTRACT (DAY FROM CURRENT_TIMESTAMP(1) - debut) * 24 * 60 * 60
       + EXTRACT (HOUR FROM sysdate - debut) * 60 * 60
       + EXTRACT (MINUTE FROM sysdate - debut) * 60) / 3600), 0) AS etat, sysdate AS date_actuelle
FROM V_MISSION_EN_COURS m
	JOIN V_MODEL v ON m.code = v.code AND m.id_employee = v.id_employee
	JOIN v_etat_mission_validation e ON e.id_composant = v.id_composant AND e.id_mission = m.id_mission;