CLEAR SCREEN
PROMPT Menu principal du projet synthèse pratique
PROMPT
PROMPT 1: Creation des tables et des relations
PROMPT 2: Requêtes d'insertion
PROMPT 3: Afficher la facturation
PROMPT 4: Faire le rabais
PROMPT 5: Mises à jour et suppression
PROMPT 6: Quitter
PROMPT
ACCEPT selection PROMPT "Entrez option 1-5: "
PROMPT
SET TERM OFF
COLUMN script NEW_VALUE choixMenu
SELECT CASE '&selection'
	WHEN '1' THEN 'crud\createVentelibre.sql'
	WHEN '2' THEN 'menuInsert.sql'
	WHEN '3' THEN 'afficherFacturation.sql'
	WHEN '4' THEN 'afficherRabais.sql'
	WHEN '5' THEN 'menuUpdateDelete.sql'
	WHEN '6' THEN 'Quitter.sql'
	ELSE 'menuPrincipal.sql'
END AS script
FROM dual;
SET TERM ON
@c:\plsql\Projet\&choixMenu