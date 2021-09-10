/*	
Autheur:	Nicolae Florin Munteanu
Fichier:	facture.sql
Travail:	Projet synthèse
Details:	Creer le package et les fonctions pour gérer 
			l'affichage et les calculs de la facturation et le rabais
*/

-- Entete du package taxepackage
CREATE OR REPLACE PACKAGE taxepackage AS 
-- Entete de function_operation
	FUNCTION coutvente(prixVente in NUMBER, quantite in NUMBER)
	RETURN NUMBER;
    
-- Entete de taxe
	FUNCTION taxe(montant in NUMBER)
    RETURN NUMBER;
END taxepackage;
/

-- Corps du taxepackage
CREATE OR REPLACE PACKAGE BODY taxepackage AS 
-- Corps de function_operation
	FUNCTION
	coutvente(prixVente IN NUMBER, quantite in NUMBER)
	RETURN NUMBER IS
	--declaration de variable locale a la fonction
	resultat NUMBER;
	BEGIN
		resultat := prixVente * quantite;
		return(resultat);
	END coutvente;

-- Corps de taxe
	FUNCTION 
	taxe(montant in NUMBER)
    RETURN NUMBER IS
	--declaration de variable locale a la fonction
	resultat NUMBER;
	BEGIN
		resultat := montant * 0.15;
        return(resultat);
	END taxe;
END taxepackage;
/