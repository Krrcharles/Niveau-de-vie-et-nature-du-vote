/*Les communes sur-sous representees*/


/*les données electorale*/
proc import datafile = 'O:\Annee1\stats\Groupe22\resultats pres 2022 communes.xlsx'
	DBMS = xlsx
	out = resultats_pres;
	run;

data resultats_pres;
set resultats_pres;
codgeo = cats(code_du_d_partement, code_de_la_commune);
run;

/*indicateurs*/
proc import datafile = 'O:\Annee1\stats\Groupe22\ificom-2021.xlsx'
	DBMS = xlsx
	out = ifi_com;
	sheet = Feuil1;
	run;

proc import datafile = 'O:\Annee1\stats\Groupe22\prsa_com.xlsx'
	DBMS = xlsx
	out = prsa_comm;
	sheet = Data;
	run;


/*on enleve les valeurs manquantes*/
data prsa_comm;
set prsa_comm(where= (prsa_com >= 0));
run;

/*on crée une table qui agrege tout en gardant bien toutes les communes*/
proc sql;
create table res_prsa_ifi
as select res.codgeo, prsa.codgeo, ifi.codgeo, votants, prsa_com, nombre_de_redevables, res.AN, BB, BP, BI
from resultats_pres res
left join prsa_comm prsa
on res.codgeo = prsa.codgeo
left join ifi_com ifi
on res.codgeo = ifi.codgeo
;
quit;

data res_prsa_ifi;
set res_prsa_ifi;
ifi_ratio = nombre_de_redevables/votants;
run;

/*---------------------------------analyses---------------------------------*/

/*premier decile rsa*/
proc sql;
create table res_prsa_top10
as select codgeo, votants, prsa_com, AN, BB, BP, BI
from res_prsa_ifi
where prsa_com >= 61.1;
quit;

proc univariate data = res_prsa_top10;
    var AN;
	weight votants;
run;

proc univariate data = res_prsa_top10;
    var BB;
	weight votants;
run;

proc univariate data = res_prsa_top10;
    var BP;
	weight votants;
run;

proc univariate data = res_prsa_top10;
    var BI;
	weight votants;
run;

/*premier centile rsa*/
proc sql;
create table res_prsa_top1
as select codgeo, votants, prsa_com, AN, BB, BP, BI
from res_prsa_ifi
where prsa_com >= 138;
quit;

proc univariate data = res_prsa_top1;
    var AN;
	weight votants;
run;

proc univariate data = res_prsa_top1;
    var BB;
	weight votants;
run;

proc univariate data = res_prsa_top1;
    var BP;
	weight votants;
run;

proc univariate data = res_prsa_top1;
    var BI;
	weight votants;
run;

/*premier decile ifi*/
proc sql;
create table res_ifi_top10
as select codgeo, votants, ifi_ratio, AN, BB, BP, BI
from res_prsa_ifi
where ifi_ratio >= 0.01684723;
quit;

proc univariate data = res_ifi_top10;
    var AN;
	weight votants;
run;

proc univariate data = res_ifi_top10;
    var BB;
	weight votants;
run;

proc univariate data = res_ifi_top10;
    var BP;
	weight votants;
run;

proc univariate data = res_ifi_top10;
    var BI;
	weight votants;
run;

/*premier centile ifi*/
proc sql;
create table res_ifi_top1
as select codgeo, votants, ifi_ratio, AN, BB, BP, BI
from res_prsa_ifi
where ifi_ratio >= 0.037;
quit;

proc univariate data = res_ifi_top1;
    var AN;
	weight votants;
run;

proc univariate data = res_ifi_top1;
    var BB;
	weight votants;
run;

proc univariate data = res_ifi_top1;
    var BP;
	weight votants;
run;

proc univariate data = res_ifi_top1;
    var BI;
	weight votants;
run;




