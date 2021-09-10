/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	update.sql
Travail:	Projet synthèse
Details:	Creer la le déclancheur qui met à jour le numClient
            dans la table venteClients, qui dépend de clients
*/
CREATE OR REPLACE TRIGGER trigger_update_client
AFTER UPDATE OF numClient ON clients
FOR EACH ROW

BEGIN
    -- si on s'est rendu ici, tout a été validé
    DBMS_OUTPUT.PUT_LINE('Modification en cascade de : ' ||:OLD.numClient);
    -- on ne fait que mettre a jour le numClint dans la table vente clients, si il y en à
    -- à partir du nouveau nom saisi
    update venteClients set numClient=:NEW.numClient where numClient=:OLD.numClient;
    dbms_output.put_line('Mise a jour sur la table venteClients complète');
END;
/