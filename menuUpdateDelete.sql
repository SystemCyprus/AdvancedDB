CLEAR SCREEN
PROMPT Menu mises à jour et suppressionss
PROMPT
PROMPT 1: Mise à juour Clients
PROMPT 2: Supprimer Produits
PROMPT 3: Retour au menu principals
PROMPT 4: Quitter
PROMPT
ACCEPT selection PROMPT "Entrez option 1-4: "
PROMPT
SET TERM OFF
COLUMN script NEW_VALUE choixMenu
SELECT CASE '&selection'
	WHEN '1' THEN 'crud\updateClients.sql'
	WHEN '2' THEN 'crud\deleteProduits.sql'
	WHEN '3' THEN 'menuPrincipal.sql'
	WHEN '4' THEN 'Quitter.sql'
	ELSE 'menuUpdateDelete.sql'
END AS script
FROM dual;
SET TERM ON
@c:\plsql\projet\&choixMenu