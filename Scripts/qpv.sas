/*Quartier prioritaire*/


proc import datafile = 'O:\Annee1\stats\Groupe22\qpv_pop.xlsx'
	DBMS = xlsx
	out = qpv_comm;
	sheet = Data;
	run;
/*nombre de valeurs non nulles*/
proc sql; 
select count(codgeo)
from qpv_comm where not(part_pop_qpv) =0;
quit;

data qpv_comm;
set qpv_comm(where= (not(part_pop_qpv) =0));
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
 create table resultats_qpv
 as select q.codgeo, libgeo, part_pop_qpv, AN, BB, BP, BI
from qpv_comm q inner join resultats_pres r on q.codgeo = r.codgeo;
quit;

PROC SGPLOT DATA = resultats_qpv;
HISTOGRAM part_pop_qpv;
TITLE "Histogramme";
RUN;
 
/*import données de pondération*/
proc import datafile = 'O:\Annee1\stats\Groupe22\pop_com.xlsx'
	DBMS = xlsx
	out = pop_com;
	sheet = Data;
	run;

proc sql;
create table resultats_qpv_pondere
as select r.codgeo, r.libgeo, part_pop_qpv, r.AN, BB, BP, BI, p_pop
from resultats_qpv r join pop_com p on r.codgeo = p.codgeo;
quit;

/*MACRON*/
proc CORR data= resultats_qpv_pondere;
var part_pop_qpv AN;
WEIGHT p_pop; 
run;

proc sgplot data = resultats_qpv_pondere;
	scatter x=part_pop_qpv y=AN;
	title "Part des suffrages exprimés pour E Macron au 1er tour en fonction de la part de la population vivant en QPV";
run;

/*JONLUK*/
proc CORR data= resultats_qpv_pondere;
var part_pop_qpv BP;
weight p_pop;
run;

proc sgplot data = resultats_qpv_pondere;
	scatter x=part_pop_qpv y=BP;
	title "Part des suffrages exprimés pour JL Mélenchon au 1er tour en fonction de la part de la population vivant en QPV";
run;

/*MLP*/
proc CORR data= resultats_qpv_pondere;
var part_pop_qpv BB;
weight p_pop;
run;

proc sgplot data = resultats_qpv_pondere;
	scatter x=part_pop_qpv y=BB;
	title "Part des suffrages exprimés pour M Le Pen au 1er tour en fonction de la part de la population vivant en QPV";
run;


/*Le Z*/
proc CORR data= resultats_qpv_pondere;
var part_pop_qpv BI;
weight p_pop;
run;

proc sgplot data = resultats_qpv_pondere;
	scatter x=part_pop_qpv y=BI;
	title "Part des suffrages exprimés pour E Zemmour au 1er tour en fonction de la part de la population vivant en QPV";
run;
