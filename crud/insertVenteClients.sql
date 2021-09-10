/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	insertVentesClient.sql
Travail:	Projet synthèse
Details:	Insertion d'un VenteClient
*/

SET SERVEROUTPUT ON
SET VERIFY OFF
-- les questions pour saisir les inputs de l'usager
ACCEPT leNumClient PROMPT "Entrer le numero du client: "
ACCEPT leNomProduit PROMPT "Entrer le nom du produit: "
ACCEPT laQuantite PROMPT "Entrer la quantité: "
ACCEPT lePrix PROMPT "Entrer le prix: "
PROMPT
DECLARE
    -- variables plsql pour contenir les inputs des variables externes
    clnt clients.numClient%TYPE := '&leNumClient';
    prod produits.nom%TYPE := '&leNomProduit';
    qnte venteclients.quantiteVendue%TYPE := '&laQuantite';
    prix number := '&lePrix';

    -- variables popour contenir les rangés de nos tables
    varClient clients%rowtype;
    varProduit produits%rowtype;
    varVente produits%rowtype;

    -- variable pour faire la mise a jour de la quantité vendue dans la table produits
    nouvelleQuantite number; 

    -- variables pour les differentes exceptions
    erreur_prix exception;
    erreur_stock exception;
    erreur_quantite exception;
BEGIN
    -- erreurs si le numero du client ou produit n'existent pas dans leur tables
	select * into varClient from clients where numClient=clnt;
    select * into varProduit from produits where nom=prod;

    -- erreurs si l'item n'est pas en stock ou la quantité est insuffisante
    if varProduit.quantiteStock is null or varProduit.quantiteStock < 1 then
        raise erreur_stock;
    elsif varProduit.quantiteStock < qnte then
        raise erreur_quantite;
    end if;

    -- si le prix est vide, on prend celui de la valeur, si il est trop petit erreur
    if prix is null then 
        prix := varProduit.prix;
    elsif prix < varProduit.prix then
        raise erreur_prix;
    end if;

    -- mise à jour de la table venteClients, avec les champs validés, et le a séquence
    INSERT INTO venteClients(codeVente, numClient, numProd, dateVente, quantiteVendue, prixVente)
    VALUES (seq_venteClients.NEXTVAL,
        varClient.numClient, varProduit.numProd, sysdate, qnte, prix);

    -- on affiche le succes et la table actuelle
	dbms_output.put_line('Vente réussie');
    dbms_output.put_line(chr(13));
    dbms_output.put_line('Voici les listes actuelle des ventes'); 
    dbms_output.put_line(chr(13));
    dbms_output.put_line(rpad('Code Vente',20)||rpad('# Client',11)||rpad('# Produit',21)||rpad('Date', 10)||rpad('Quantité',8)||rpad('Prix', 12));  
    FOR varVente IN (select * from venteClients) LOOP
        DBMS_OUTPUT.PUT_LINE(
            rpad(varVente.codeVente,20)||
            rpad(varVente.numClient,11)||
            rpad(varVente.numProd,21)||
            rpad(varVente.dateVente, 10)||
            rpad(varVente.quantiteVendue,8)||
            rpad(varVente.prixVente, 12));
    END LOOP;

    -- mise a jour quantite dans la table produits
    nouvelleQuantite := varProduit.quantitestock - qnte;
    update produits set quantitestock = nouvelleQuantite where numprod = varProduit.numProd;
    dbms_output.put_line(chr(13));
    dbms_output.put_line('Quantité mise à jour dans la table produits!');
    commit;
    --besoin de code pour afficher la liste existante
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('Code client ou nom produit inexistants');
        dbms_output.put_line(chr(13));
        dbms_output.put_line('Voici les listes clients et produits'); 
        dbms_output.put_line(chr(13));
        dbms_output.put_line(rpad('Num',15)||rpad('Nom',20)||rpad('Prénom ',20));  
        FOR varClient IN (select * from clients) LOOP
            DBMS_OUTPUT.PUT_LINE(rpad(varClient.numClient,15)||
            rpad(varClient.nomClient,20)||
            rpad(varClient.prenomClient,20));
        END LOOP;
        dbms_output.put_line(chr(13));
        dbms_output.put_line(rpad('Num',15)||rpad('Nom',20)||rpad('Stock',20)||rpad('Prix',10));
        FOR varProduit IN (select * from produits) LOOP
            DBMS_OUTPUT.PUT_LINE(rpad(varProduit.numProd,15)||
            rpad(varProduit.nom,20)||
            rpad(varProduit.quantiteStock,15)||
            rpad(varProduit.prix,10));
        END LOOP;
    WHEN erreur_prix THEN
        dbms_output.put_line('Le prix de vente doit etre sperieur au prix du produit');
    WHEN erreur_stock THEN
        dbms_output.put_line('Ce produit n''est pas disponnible');
    WHEN erreur_quantite THEN
        dbms_output.put_line('La quantite demandée est plus grande que celle disponnible');
	WHEN others THEN	
		dbms_output.put_line('Une erreur s''est produite!');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuInsert.sql