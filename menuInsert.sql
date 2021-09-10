CLEAR SCREEN
PROMPT Menu inserons
PROMPT
PROMPT 1: Ajouter un Client
PROMPT 2: Ajouter un Produit
PROMPT 3: Ajouter une VenteClient
PROMPT 4: Retour au menu principal
PROMPT 5: Quitter
PROMPT
ACCEPT selection PROMPT "Entrez option 1-5: "
PROMPT
SET TERM OFF
COLUMN script NEW_VALUE choixMenu
SELECT CASE '&selection'
	WHEN '1' THEN 'crud\insertClients.sql'
	WHEN '2' THEN 'crud\insertProduits.sql'
	WHEN '3' THEN 'crud\insertVenteClients.sql'
	WHEN '4' THEN 'menuPrincipal.sql'
	WHEN '5' THEN 'Quitter.sql'
	ELSE 'menuInsert.sql'
END AS script
FROM dual;
SET TERM ON
@c:\plsql\projet\&choixMenu