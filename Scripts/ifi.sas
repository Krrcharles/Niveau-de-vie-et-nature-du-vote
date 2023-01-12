/*Part de payeur de l'ifi par commune*/

proc import datafile = 'O:\Annee1\stats\Groupe22\ificom-2021.xlsx'
	DBMS = xlsx
	out = ifi_com;
	sheet = Feuil1;
	run;

proc import datafile = 'O:\Annee1\stats\Groupe22\resultats pres 2022 communes.xlsx'
	DBMS = xlsx
	out = resultats_pres;
	run;

data resultats_pres;
set resultats_pres;
codgeo = cats(code_du_d_partement, code_de_la_commune);
run;

proc sql; 
 create table resultats_ifi
 as select q.codgeo, r.codgeo, nombre_de_redevables, r.AN, BB, BP, BI
from ifi_com q join resultats_pres r on q.codgeo = r.codgeo;
quit;


/* importer les données*/

proc import datafile = 'O:\Annee1\stats\Groupe22\pop_com'
	DBMS = xlsx
	out = pop_com_all;
	sheet = Data;
	run; 

data pop_com;
set pop_com_all(where=(an = "2018"));
run;

proc sql;
create table resultat_ifi_ratio
as select p.codgeo, r.codgeo, nombre_de_redevables,p_pop, r.AN, BB, BP, BI
from pop_com p
join resultats_ifi r
on p.codgeo= r.codgeo;
quit; 

Data resultat_ifi_ratio;
set resultat_ifi_ratio;
ratio_ifi = nombre_de_redevables/p_pop;
run;

PROC SGPLOT DATA = resultat_ifi_ratio;
HISTOGRAM ratio_ifi;
TITLE "Histogramme ratio ifi";
RUN;

/*MACRON*/
proc CORR data= resultat_ifi_ratio;
var ratio_ifi AN;
run;

proc sgplot data = resultat_ifi_ratio;
	scatter x=ratio_ifi y=AN;
	title "Résultats d'E.Macron au 1er tour en fonction du nombre de la population IFI";
run;

/*JONLUK*/
proc CORR data= resultat_ifi_ratio;
var ratio_ifi BP;
run;

proc sgplot data = resultat_ifi_ratio;
	scatter x=ratio_ifi y=BP;
	title "Résultats de JL Mélenchon au 1er tour en fonction du nombre de la population IFI";
run;

/*MLP*/
proc CORR data= resultat_ifi_ratio;
var ratio_ifi BB;
run;

proc sgplot data = resultat_ifi_ratio;
	scatter x=ratio_ifi y=BB;
	title "Résultats de M Le Pen au 1er tour en fonction du nombre de la population IFI";
run;


/* Le Z*/
proc CORR data= resultat_ifi_ratio;
var ratio_ifi BI;
run;

proc sgplot data = resultat_ifi_ratio;
	scatter x=ratio_ifi y=BI;
	title "Résultats de E Zemmour au 1er tour en fonction du nombre de la population IFI";
run;
