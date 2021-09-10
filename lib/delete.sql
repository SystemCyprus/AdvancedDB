/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	delete.sql
Travail:	Projet synthèse
Details:	Creer le déclancheur qui éfface toutes les occurences d'un produit de la table venteClients
            suite a une supprimation de ce produit dans la table produits
*/
CREATE OR REPLACE TRIGGER trigger_delete_produits
AFTER DELETE ON produits
FOR EACH ROW

DECLARE
    -- pour contenir la valeur qui vient d'etre éffacéé dans la table produit
    -- avant d'effacer chacune de ses occurences dans la table venteClients
	numProduit produits.numProd%TYPE := :OLD.numProd;
    -- pour éviter d'utiliser une exception ou un curseur explicite,
    -- on compte popur s'assurer de pas faire u delete sur null
	numCompte number := 0;
    -- pour contenir les rangés du curseur implicite de la table venteClients
    rowProduit venteClients%ROWTYPE;
BEGIN
    dbms_output.put_line('Modification en cascade du produit: ' ||:OLD.nom);
    -- curseur implicite basic, si on s'est rendu ici, il a deja été valide, donc pas d'exception redondante
    -- on s'assure que il y a au moins un row du produit en question dans la table venteclients
	select count(numProd) into numCompte from venteClients where upper(numProd)=upper(numProduit);
	if numCompte > 0 then
        -- on supprime ce produit, autant de fois qu'il se trouve dans la liste
        DELETE FROM venteClients where upper(numProd)=upper(numProduit);
    end if;
END;
/