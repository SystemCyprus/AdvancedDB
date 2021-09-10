/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	insertClient.sql
Travail:	Projet synthèse
Details:	Insertion d'un client
*/

SET SERVEROUTPUT ON
SET VERIFY OFF
-- des variables externes captent les user input
ACCEPT leNom PROMPT "Entrer le nom: "
ACCEPT lePrenom PROMPT "Entrer le prenom: "
ACCEPT leTelephone PROMPT "Entrer le telephone: "
ACCEPT leNoRue PROMPT "Entrer le numero de la rue: "
ACCEPT leNomRue PROMPT "Entrer le nom de la rue: "
ACCEPT laVille PROMPT "Entrer le ville: "
ACCEPT laProvince PROMPT "Entrer le province: "
ACCEPT leCodepostal PROMPT "Entrer le codepostal: "
ACCEPT lePays PROMPT "Entrer le pays: "
PROMPT
BEGIN
    -- on essaye le insert, assez basic pour un pas faire un curseur explicite, et on empêche les doublons aussi
    INSERT INTO clients(numclient, nomclient, prenomclient, telephone, norue, nomrue, ville, province, codepostal, pays)
    VALUES (
        substr('&leNom',1,3)||substr('&lePrenom',1,2),
        '&leNom', '&lePrenom', '&leTelephone', '&leNoRue', '&leNomRue', '&laVille', '&laProvince', '&leCodepostal', '&lePays' 
    );
    -- commit pour que le user peut voir le changement tout de suite
    commit;
	dbms_output.put_line('Insertion de client reussie!');
    --besoin de code pour afficher la liste existante
EXCEPTION
    -- exception doublon avec message approprié
    WHEN dup_val_on_index THEN
		dbms_output.put_line('Le noclient existe deja!');
	WHEN others THEN	
		dbms_output.put_line('Une erreur s''est produite!');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuInsert.sql