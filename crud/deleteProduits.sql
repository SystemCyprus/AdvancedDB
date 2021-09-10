/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	deleteProduits.sql
Travail:	Projet synthèse
Details:	Supprimer un produit
*/

SET SERVEROUTPUT ON
SET VERIFY OFF
-- variable externe pour saisir le user input
ACCEPT leNom prompt "Entrez le nom du produit à supprimer: "
PROMPT
DECLARE
	-- variable interne à partir de l'externe
	nomProduit varchar2(10):='&leNom';
	rowProduit produits%rowtype;

BEGIN
	-- curseur implicite qui fait le basic qu'on a besoin. on utilise le nom et non le id unique par simplicité
	-- pour cet exemple on ne fera pas de doublons de nom produit, sinon on aura plus d'une ligne de retour
	-- et il y aura une exception non catchée qui brisera le programme. on devrait alors utiliser un 
	-- curseur explicite avec try catch. ou se servir du numproduit(clé primaire)
	select * into rowProduit from produits where nom=nomProduit;
		insert into  produitsupprimes select * from produits where upper(nom) = upper(nomProduit);
		delete from produits where upper(nom)=upper(nomProduit);
	-- commit pour que les changements prennent effet là la
	commit;
	dbms_output.put_line('Suppression éfectuée avec succès!');
	dbms_output.put_line(chr(13));
	-- on affiche la liste actuuelle
	dbms_output.put_line('Voici la liste actuelle de Produits');
	dbms_output.put_line(chr(13));
	dbms_output.put_line(rpad('Num',15)||rpad('Nom',20)||rpad('Stock',20)||rpad('Prix',10));
	FOR varProduit IN (select * from produits) LOOP
		DBMS_OUTPUT.PUT_LINE(rpad(varProduit.numProd,15)||
		rpad(varProduit.nom,20)||
		rpad(varProduit.quantiteStock,15)||
		rpad(varProduit.prix,10));
	END LOOP;
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Le code n''existe pas');
    when others THEN
        dbms_output.put_line('Une erreur s''est produite');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuUpdateDelete.sql