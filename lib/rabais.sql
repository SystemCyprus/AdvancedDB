/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	rabais.sql
Travail:	Projet synthèse
Details:	Creer la procedure pour faire le rabais
*/

-- procedure pour faire un rabai sur le prix unitaire
CREATE OR REPLACE PROCEDURE
    -- les deux parametres sont pour isoler les ventes d'un client pour une date spécifique
    procedure_rabais(varNumClient in varchar2, varDate in date) is
BEGIN
    DECLARE
        -- le courseur qui contient les infoss sur lesquelles nous allons travailler
        CURSOR cur_venteClients IS select * from venteClients where numClient = varNumClient and to_date(dateVente) = varDate for update of prixVente;
        -- les rangees que nous allons fetch du curseur une à une seront accessibles avec row_venteClients
        row_venteClients cur_venteClients%ROWTYPE;
        -- prix total d'une vente
        num_totalVentes number;
        -- variable qui contient le rabais à appliquer, que nous calculons en fonction du prix total de la vente
        num_rabais number;
        -- exception si aucun e vente ne correspont a la date et au client choisis
        erreur_vente exception;
    BEGIN
        -- ouverture explicite du curseur
        OPEN cur_venteClients;
        -- lecture de la premiere rangee, avant la boucle, pour voir si il y en a
        FETCH cur_venteClients INTO row_venteClients;
        -- exception si aucune rangée n'est trouvée, pour la date et le client donnés
        if cur_venteClients%NOTFOUND THEN
            raise erreur_vente;
        else
            -- boucle pour chacune des rangées qui remplit les conditions, commencant par celle deja assignee ci haut
            WHILE cur_venteClients%FOUND LOOP
                -- on se sert de la fonction coutvente du package taxepackage pour calculer le cout total de la vente courrante
                num_totalVentes:= TAXEPACKAGE.coutvente(row_venteClients.prixVente, row_venteClients.quantiteVendue);

                -- calcul du rabais, dépendant du total de la vente
                if num_totalVentes <= 1000 then
                    num_rabais := 0.05;
                    dbms_output.put_line('Rabais de 5% appliqué sur la commande '||row_venteClients.codeVente);
                elsif num_totalVentes <= 5000 then
                    num_rabais := 0.10;
                    dbms_output.put_line('Rabais de 10% appliqué sur la commande '||row_venteClients.codeVente);
                elsif num_totalVentes >5000 then
                    num_rabais := 0.15;
                    dbms_output.put_line('Rabais de 15% appliqué sur la commande '||row_venteClients.codeVente);
                end if;
                
                -- une fois que le le rabais à été déterminé, on peut mettre à jour le prixVente dans la table venteClients
                UPDATE venteClients
                set prixVente = row_venteClients.prixVente - row_venteClients.prixVente * num_rabais
                WHERE current of cur_VenteClients;

                --lecture de la prochaine rangée si il y en reste, sinon on sort de la boucle
                FETCH cur_venteClients INTO row_venteClients;
            end loop;
        end if;
        -- fermeture explicite du curseur
        CLOSE cur_venteClients;
        commit;
    EXCEPTION
        when erreur_vente then
            dbms_output.put_line('Aucun produit n'' a ete vendu a ce client pour cette date');
    END;
END procedure_rabais;
/