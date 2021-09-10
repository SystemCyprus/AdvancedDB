/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	createVentelibre.sql
Travail:	Projet synthèse
Details:	Creation des 3 tables de notre projet,
            et des triggers, fonctions, procedures
            de la base de données ventelibre.dbf
*/

SET SERVEROUTPUT ON
SET VERIFY OFF

-- creation des tables clients, produits, venteclients et produitsupprimes
-- appel au package, fonction, procédure et triggers du dossier lib

BEGIN
	-- table clients
	DECLARE
	    table_existe_clients EXCEPTION;
	    PRAGMA EXCEPTION_INIT(table_existe_clients,-955);
	BEGIN
	execute immediate'create table Clients(
			numClient varchar2(5) primary key, 
			nomClient varchar2(20) not null, 
			prenomClient varchar2(20) not null, 
			telephone varchar2(13) not null
				constraint ck_clients_telephone check (regexp_like(telephone, ''^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$'')), 
			noRue number(6) not null, 
			nomRue varchar2(20) not null,
			ville varchar2(15) not null, 
			province varchar2(15) not null, 
			codePostal varchar2(6) not null
				constraint ck_clients_codePostal check (regexp_like(codePostal, ''^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$'')),
			pays varchar2(20))';
		dbms_output.put_line('La table clients est creee!');					
	EXCEPTION
		WHEN table_existe_clients THEN
			dbms_output.put_line('Table clients existe deja!');
	END;
	
	-- table produits
	DECLARE
		table_existe_produits EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_existe_produits,-955);
	BEGIN
		execute immediate 'create table produits(
				numProd varchar2(11) primary key,
				nom varchar2(20) not null,
				quantiteStock NUMBER(10),
				prix NUMBER(10,2))';
		dbms_output.put_line('La table produits est creee!');		
	EXCEPTION
		WHEN table_existe_produits THEN
			dbms_output.put_line('Table produits existe deja!');
	END;

	-- table centeClients
    DECLARE
		table_existe_venteClients EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_existe_venteClients,-955);
	BEGIN
		execute immediate 'create table VenteClientS(
				codeVente varchar2(20) primary key,
				numClient varchar2(5),
				numProd varchar2(11),
				dateVente date,
				quantiteVendue number(10),
				prixVente number(10,2),  
				constraint fk_venteClients_numClient foreign key(numClient) references Clients(numClient),
				constraint fk_venteClients_numProd foreign key(numProd) references Produits(numProd))';
		dbms_output.put_line('La table venteclients est creee!');		
	EXCEPTION
		WHEN table_existe_venteClients THEN
			dbms_output.put_line('Table venteclients existe deja!');
	END;

	-- creation de la table produitsupprimes
	DECLARE
		table_existe_produitSupprimes EXCEPTION;
		PRAGMA EXCEPTION_INIT(table_existe_produitSupprimes,-955);
	BEGIN
		execute immediate 'create table produitsupprimes(
				numProd varchar2(11) primary key,
				nom varchar2(20) not null,
				quantiteStock NUMBER(10),
				prix NUMBER(10,2))';
		dbms_output.put_line('La table produitsSupprimes est creee!');		
	EXCEPTION
		WHEN table_existe_produitSupprimes THEN
			dbms_output.put_line('Table produitsSupprimes existe deja!');
	END;

	-- creation de la sequence pour la clé primaire de la table produits, numProduit
	DECLARE 
		sequence_existe_produit EXCEPTION;
		PRAGMA EXCEPTION_INIT(sequence_existe_produit,-955);
	BEGIN
		execute immediate 'create sequence seq_codeProduit
    			MINVALUE 1000000000
    			MAXVALUE 9999999999
    			start with 1000000000
    			increment by 1
    			cycle';
		dbms_output.put_line('La séquence seq_codeProduit à été crée');		
	EXCEPTION
		WHEN sequence_existe_produit THEN
			dbms_output.put_line('La Séquence seq_codeProduit existe deja!');
	END;

	-- création de la séquence pour la clé primaire de la table venteClients
	DECLARE
		sequence_existe_vente EXCEPTION;
		PRAGMA EXCEPTION_INIT(sequence_existe_vente,-955);
	BEGIN
		execute immediate 'create sequence seq_venteClients
				minvalue 1
				maxvalue 99999999999999999999
				start with 1
				increment by 1
				cycle';
		dbms_output.put_line('La séquence seq_codeProduit à été crée');		
	EXCEPTION
		WHEN sequence_existe_vente THEN
			dbms_output.put_line('La Séquence seq_codeProduit existe deja!');
	END;
EXCEPTION
	when others then
		dbms_output.put_line('Une erreur s''est produite');
END;
/

-- on appelle les fichier pour les procedures, fonctions, packages, et triggers
@c:\plsql\projet\lib\update.sql
@c:\plsql\projet\lib\delete.sql
@c:\plsql\projet\lib\facture.sql
@c:\plsql\projet\lib\rabais.sql
PAUSE Appuyez sur une touche pour retourner
SET VERIFY ON
@c:\plsql\projet\menuPrincipal.sql