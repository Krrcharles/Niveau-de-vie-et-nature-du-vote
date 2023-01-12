/*Traitement de la BDD des revenus médians des communes*/

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

proc means data = rev_med_comm p10 p20 p30 p40 p50 p60 p70 p80 p90;
title "Déciles des revenus médians des communes";
var med18;
run;
