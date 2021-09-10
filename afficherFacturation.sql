/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	afficherFacturation.sql
Travail:	Projet synthèse
Details:	Affiche la facturation
*/
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT leNumClient PROMPT "Entrer le numero du client: "
ACCEPT laDate PROMPT "Entrer la date: "
PROMPT
DECLARE
    -- on prend les variables externes avec les input usager et on les passes aux variables plsql
    varNumClient venteClients.numClient%TYPE := '&leNumClient';
    varDate venteClients.dateVente%TYPE := '&laDate';

    -- curseur explicite et rangée pour les infos clients
    CURSOR cur_client is select * from clients where numClient = varNumclient;
    row_clients clients%ROWTYPE;

    -- curseur explicite et rangée pour les infos des ventesF
    CURSOR cur_venteClients IS select * from venteClients where numClient = varNumClient and to_date(dateVente) = varDate;
    row_vente venteClients%ROWTYPE;

    -- variables pour le cout de vente, cout total et taxe
    var_coutVente number;
    var_total  number := 0;
    var_taxe number(10,2);

    -- variables pour afficher les erreurs
    erreur_client exception;
    erreur_vide exception;
BEGIN
    open cur_venteClients;
    -- on lis la première rangée de du curseur de la table venteClient pour s'assurer 
    -- d'en avoir au moins une vant d'afficher des infos qui peuvent ne pas être trouvees
    fetch cur_venteClients into row_vente; 
    if cur_venteClients%NOTFOUND then
        raise no_data_found;
    else
        -- on ouvre le curseur de facon explicite pour avoir plus de controle sur le fetch et
        open cur_client;
        -- on lit la première rangée du curseur explicite, si par erreur il y en à plus d'une, on la lira meme pas, donc pas de crash
        fetch cur_client into row_clients;
        dbms_output.put_line(chr(9)||'NumClient: '||row_clients.numClient);
        dbms_output.put_line(chr(9)||'Nom: '||row_clients.nomClient);
        dbms_output.put_line(chr(9)||'Prénom: '||row_clients.prenomClient);
        dbms_output.put_line(rpad('NumProd', 12)||rpad('Prix', 12)||rpad('Quantité', 12)||rpad('Sous-total', 12));
        -- on loop tant qu'il reste des rangees non manipulés
        while cur_venteClients%found loop
            -- on calcule le cout de la vente et les totaux dans des variables, pour les afficher ci-bas
            var_coutVente := taxepackage.coutvente(row_vente.quantiteVendue, row_vente.prixVente);
            var_total := var_total + var_coutVente;
            dbms_output.put_line(
                rpad(row_vente.numProd, 12)||
                rpad('$'||to_char(row_vente.prixVente), 12)||
                rpad(row_vente.quantiteVendue, 12)||
                rpad('$'||var_coutVente, 12));
            -- on prend la rangée suivante apres avoir affichés la courante
            fetch cur_venteClients into row_vente;
        end loop;
        -- on oublie pas de fermer le curseur
        close cur_client;
        -- on calcule la taxe avec la fonction de la procedure
        var_taxe := taxepackage.taxe(var_total);
        dbms_output.put_line(chr(9)||chr(9)||chr(9)||rpad('Total', 12)||rpad(to_char('$'||var_total), 24));
        dbms_output.put_line(chr(9)||chr(9)||chr(9)||rpad('Taxes(15%)', 12)||rpad(to_char('$'||var_taxe), 24));
        dbms_output.put_line(rpad(chr(9),28)||'----------');
        dbms_output.put_line(chr(9)||chr(9)||chr(9)||rpad('Grand Total', 12)||rpad('$'||to_char(var_total+var_taxe), 24));
    end if;
    close cur_venteClients;
    
EXCEPTION
    when erreur_client then
        dbms_output.put_line('Ce client n''existe pas');
        dbms_output.put_line(chr(13));
        dbms_output.put_line('Voici la liste de clients'); 
        dbms_output.put_line(chr(13));
        dbms_output.put_line(rpad('Num',15)||rpad('Nom',20)||rpad('Prénom ',20));  
        FOR varClient IN (select * from clients) LOOP
            DBMS_OUTPUT.PUT_LINE(rpad(varClient.numClient,15)||
            rpad(varClient.nomClient,20)||
            rpad(varClient.prenomClient,20));
        END LOOP;
    when no_data_found then
        dbms_output.put_line('Aucun produit n''a été vendu à cette date par ce client');
        dbms_output.put_line(chr(13));
        dbms_output.put_line('Voici les listes actuelle des ventes'); 
        dbms_output.put_line(chr(13));
        dbms_output.put_line(rpad('Code Vente',20)||rpad('# Client',11)||rpad('# Produit',21)||rpad('Date', 10)||rpad('Quantité',8)||rpad('Prix', 12));  
        FOR varVente IN (select * from venteClients) LOOP
        dbms_output.put_line(
            rpad(varVente.codeVente,20)||
            rpad(varVente.numClient,11)||
            rpad(varVente.numProd,21)||
            rpad(varVente.dateVente, 10)||
            rpad(varVente.quantiteVendue,8)||
            rpad(varVente.prixVente, 12));
        END LOOP;
    when erreur_vide then
        dbms_output.put_line('Le num client et la date sont nécéssaires');
    when others then
        dbms_output.put_line('Une erreur s''est produite');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuPrincipal.sql