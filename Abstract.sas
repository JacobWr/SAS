libname jw "\\Mac\Home\Desktop\Uni Bremen\Master\2.Semester\Statistik in der Epidemiologie\dats";

ODS PDF <

data Herz;
	set jw.herz;
run;

*Altersgruppen bilden, Variable für Zeit des Follow Up nach Krankenhaus, 
nur Personen die Krankenhausaufenthalt überlebt haben inkludieren;
data herz;
	set jw.herz;
	agegrp75 = .;
	NKD = Zeit_FU - Stat_Dauer;
	if Alter >= 65 then agegrp65 = 1;
	if Alter < 65 then agegrp65 = 0;
	if DSTAT = 0;
run;

*Hazard Ratio auf Proportionalität testen mit Kaplan-Meier Kurve;

proc sort data=herz;
	by agegrp65;
run;


proc lifetest data=herz plots=(s(cb = hw test atrisk=0 to 2300 by 400) ls) notable; *plot=(s, lls);
	time NKD*Status(0);
	strata Herz_insuff;
	where agegrp65=1;
run;

ods trace off;
proc phreg data=herz plots(overlay)=survival;
	model NKD*Status(0)=Herz_insuff sex Alter /rl;
	by agegrp65;
run;

ods output ParameterEstimates=Cox_Regression;
proc phreg data=herz plots(overlay)=survival;
	model NKD*Status(0)=Herz_insuff sex Alter /rl;
quit;

proc print data=Cox_Regression noobs;
run;

*title;

options nodate nonumber center;
ods html file = "\\Mac\Home\Desktop\Uni Bremen\Master\2.Semester\Statistik in der Epidemiologie\dats\cox_regression.html";
title 'cox regression';
ods text = 'Cox_Regression';
proc print data = Cox_regression;
quit;
run;
ods _all_ close;

ods excel file="\\Mac\Home\Desktop\Uni Bremen\Master\2.Semester\Statistik in der Epidemiologie\dats\cox_regression.xlsx";
	proc print data=Cox_regression;
	run;
ods excel close;







