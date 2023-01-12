proc import datafile = 'O:\Annee1\stats\Groupe22\comm_med.xlsx'
	DBMS = xlsx
	out = rev_med_comm;
	sheet = COM;
	run;

data rev_med_comm;
set rev_med_comm;
label med18='revenu médian';
run;

proc contents data = rev_med_comm;
run;

proc sql; 
 create table nombre_de_valeurs_manquantes
 as select count(CODGEO)
from rev_med_comm table where not(MED18 >0);
quit;

PROC SGPLOT DATA = rev_med_comm;
HISTOGRAM MED18;
TITLE "Histogramme des revenus médians des communes de France";
RUN;

proc import datafile = 'O:\Annee1\stats\Groupe22\resultats pres 2022 communes.xlsx'
	DBMS = xlsx
	out = resultats_pres;
	run;

data resultats_pres;
set resultats_pres;
codgeo = cats(code_du_d_partement, code_de_la_commune);
run;

/*MACRON*/

proc sql; 
 create table comm_rev_macron
 as select rev.codgeo, med18, AN
from resultats_pres res join rev_med_comm rev on res.codgeo = rev.codgeo where med18 >0;
quit;

data comm_rev_macron;
set comm_rev_macron;
label med18 = 'revenu médian' AN = 'part des suffrages exprimés pour E.Macron';
run;

proc sgplot data = comm_rev_macron;
	scatter x=med18 y=AN;
	title "Résultats d'E.Macron au 1er tour en fonction du revenu médian des communes";
run;

proc sgplot data = comm_rev_macron;
	reg x = med18 y= AN;
	run;

proc reg data= comm_rev_macron;
model AN= med18;
run;

/*MELENCHON*/

proc sql; 
 create table comm_rev_melenchon
 as select rev.codgeo, med18, BP
from resultats_pres res join rev_med_comm rev on res.codgeo = rev.codgeo where med18 >0;
quit;

data comm_rev_melenchon;
set comm_rev_melenchon;
label med18 = 'revenu médian' BP = 'part des suffrages exprimés pour JL Melenchon';
run;

proc sgplot data = comm_rev_melenchon;
	reg x = med18 y= BP;
	run;

proc reg data= comm_rev_melenchon plots(maxpoints = none);
model BP= med18;
run;

/*Marine Le Pen*/

proc sql; 
 create table comm_rev_lepen
 as select rev.codgeo, med18, BB
from resultats_pres res join rev_med_comm rev on res.codgeo = rev.codgeo where med18 >0;
quit;

data comm_rev_lepen;
set comm_rev_lepen;
label med18 = 'revenu médian' BB = 'part des suffrages exprimés pour M.Le Pen';
run;

proc sgplot data = comm_rev_lepen;
	reg x = med18 y= BB;
	run;

proc reg data= comm_rev_lepen plots(maxpoints = none);
model BB= med18;
run;

