/*Part d'allocataire du RSA par commune*/

proc import datafile = 'O:\Annee1\stats\Groupe22\prsa_com.xlsx'
	DBMS = xlsx
	out = prsa_comm;
	sheet = Data;
	run;

data prsa_comm;
set prsa_comm(where= (prsa_com >= 0));
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
 create table resultats_rsa
 as select q.codgeo, libgeo, prsa_com, r.AN, BB, BP, BI
from prsa_comm q inner join resultats_pres r on q.codgeo = r.codgeo;
quit;

PROC SGPLOT DATA = prsa_comm;
HISTOGRAM prsa_com;
TITLE "Histogramme";
RUN;

/* importer les données*/

proc import datafile = 'O:\Annee1\stats\Groupe22\pop_com'
	DBMS = xlsx
	out = pop_com;
	sheet = Data;
	run; 

proc sql;
create table resultat_rsa_pondere
as select p.codgeo, r.libgeo, prsa_com, r.AN, BB, BP, BI, p_pop
from pop_com p
join resultats_rsa r
on p.codgeo= r.codgeo;
quit; 

/*MACRON*/
proc CORR data= resultat_rsa_pondere;
var prsa_com AN;
weight p_pop;
run;

proc sgplot data = resultat_rsa_pondere;
	scatter x=prsa_com y=AN;
	title "Résultats d'E.Macron au 1er tour en fonction du nombre de la population allocataire du RSA pour 1000 habitant";
run;

/*JONLUK*/
proc CORR data= resultat_rsa_pondere;
var prsa_com BP;
weight p_pop;
run;

proc sgplot data = resultat_rsa_pondere;
	scatter x=prsa_com y=BP;
	title "Résultats de JL Mélenchon au 1er tour en fonction du nombre de la population allocataire du RSA pour 1000 habitant";
run;

/*MLP*/
proc CORR data= resultat_rsa_pondere;
var prsa_com BB;
weight p_pop;
run;

proc sgplot data = resultat_rsa_pondere;
	scatter x=prsa_com y=BB;
	title "Résultats de M Le Pen au 1er tour en fonction du nombre de la population allocataire du RSA pour 1000 habitant";
run;


/* Le Z */

proc CORR data= resultat_rsa_pondere;
var prsa_com BI;
weight p_pop;
run;

proc sgplot data = resultat_rsa_pondere;
	scatter x=prsa_com y=BI;
	title "Résultats de E Zemmour au 1er tour en fonction du nombre de la population allocataire du RSA pour 1000 habitant";
run;
