/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	updateClients.sql
Travail:	Projet synthèse
Details:	Mettre à jour un client
*/

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT leNumClient PROMPT "Entrer le numero du client: "
ACCEPT leNumNouveau PROMPT "Entrer le nouveau numero: "
PROMPT
DECLARE
    -- variable pour contenir la rangee qu'on verifie, du meme type que les rangés de la table clients
    rowClient clients%ROWTYPE;
    -- variables externes deviennent variables plsql pour plus de contole et clarté
    numVieux clients.numClient%TYPE := '&leNumClient';
    numNouveau clients.numClient%TYPE := '&leNumNouveau';
BEGIN
    -- curseur explite juste pour l'exception
    select * into rowClient from clients where numClient = numVieux;
    update clients set numClient=numNouveau where numClient=numVieux;
    -- commit pour que les changement soient appliques aux tables
    commit;
    dbms_output.put_line('Mise à jour éfectuée avec succès');
    -- cde pour afficher la liste actuelle de clients
EXCEPTION
    -- exception si le curseur implicite trouve rien
    when no_data_found then
        dbms_output.put_line('Aucun client avec ce numClient existe');
    -- autres erreurs si ici pour pas crasher le programme
    when others then
        dbms_output.put_line('Une erreur s''est produite');
END;
/

PAUSE Appuyez sur une touche pour retourner

SET VERIFY ON

@c:\plsql\projet\menuUpdateDelete.sql