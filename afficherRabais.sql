/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	afficherRabais.sql
Travail:	Projet synthèse
Details:	Affiche le rabais
*/
SET SERVEROUTPUT ON
SET VERIFY OFF
PROMPT
ACCEPT leNumClient PROMPT "Entrer le numClient: "
ACCEPT laDate PROMPT "Entrer la date: "
PROMPT
DECLARE
    -- variables internes pour saisir le user input externe, du meme type que leurs correspondants table
    varNumClient venteClients.numClient%TYPE := '&leNumClient';
    varDate venteClients.dateVente%TYPE := '&laDate';
    -- variable pour contenir les rangéés du curseur implicite de la table venteclients
    rowVente venteClients%ROWTYPE;
    erreur_vide exception;
BEGIN
    if varDate is null then
        raise erreur_vide;
    else
        if varNumclient is null then
            dbms_output.put_line(rpad('Client', 12)||rpad('Sous-total',12)||'Taxe');
            for rowVente in (select numClient, sum(prixVente*quantiteVendue) as Total, sum(taxepackage.taxe(prixVente*quantiteVendue)) as Taxe from venteClients group by numClient) loop
                dbms_output.put_line(rpad(rowVente.numClient, 12)||rpad(rowVente.Total,12)||rowVente.Taxe);
            end loop;
        else
            procedure_rabais(varNumClient, varDate);
            dbms_output.put_line(chr(13));
            dbms_output.put_line(rpad('Client', 12)||rpad('Sous-total',12)||'Taxe');
            -- un curseur implicite juste pour afficher qqes infos. 
            for rowVente in (select numClient, sum(prixVente*quantiteVendue) as Total, sum(taxepackage.taxe(prixVente*quantiteVendue)) as Taxe from venteClients where numClient = varNumClient group by numClient) loop
                dbms_output.put_line(rpad(rowVente.numClient, 12)||rpad(rowVente.Total,12)||rowVente.Taxe);
            end loop;
        end if;
    end if;
    
EXCEPTION
    when erreur_vide then
        dbms_output.put_line('La date est nécéssaire');
    when others then
        dbms_output.put_line('Une erreur s''est produite');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuPrincipal.sql