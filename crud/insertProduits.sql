/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	insertProduits.sql
Travail:	Projet synthèse
Details:	Insertion d'un produit

*/

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT leNom PROMPT "Entrer le nom: "
ACCEPT laQuantite PROMPT "Entrer la quantité: "
ACCEPT lePrix PROMPT "Entrer le prix: "
PROMPT
BEGIN
    -- insertion du produit, a partir des user input. on pourrait valider des trucs de plus au besoin
    INSERT INTO produits(numProd, nom, quantiteStock, prix)
    VALUES ('P'||seq_codeProduit.NEXTVAL,
        '&leNom', '&laQuantite', '&lePrix');
    -- commit pour que le tout prenne effet
    commit;
	dbms_output.put_line('Insertion de client reussie!');
EXCEPTION
	WHEN others THEN	
		dbms_output.put_line('Une erreur s''est produite!');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuInsert.sql