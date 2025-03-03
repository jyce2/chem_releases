
*********************************************************************
*  Title:         ChPRS annual report generation (Step 3 of 3)         
*                                                                    
*  Description:   Generating NC county map by frequency of acute toxic releases				  
*                     
*------------------------------------------------------------------- 
*
*  Input:         SAS dataset 
*
*  Output:        PDF of map
*
*  Created:       01-31-2025
*
*  Last updated:  02-28-2025
*                                        
********************************************************************;

/* Year of report */
%let year = 2022; 

/* Path for library name */
libname c '~/work';

/* Path for PDF file */
ods pdf file="~/work/&year.report_step3.PDF";

title1 "&year. report step 3 of 3";
title2 "Generating NC county map by frequency of acute toxic releases";
ods exclude EngineHost;
proc contents data=c.ds&year;
run;
title;


/*MAP*/ /*import map from predetermined maps in SAS*/

/*exact location (lat, long) for mapping data set */
proc gproject
	data=maps.counties out = nc;
	where state = 37;
	id state county;
run;

/* cross-reference FIPS county codes for county data set*/
proc sql number;
	create table cnty as 
	select state, county, statename, countynm 
	from mapssas.cntyname
	where statename = "North Carolina";
quit;

/* merge to match by county name for final mapping data set*/
proc sql number;
	create table c.nc(drop=state county rename=(countynm=county)) as 
	select * from nc as a
		inner join cnty as b
		on a.county = b.county;
quit;
	


/* apply permanent format values to county var in ds */
proc format;
	value county_ 
	1='Alamance' 2='Alexander' 
		3='Alleghany' 4='Anson' 
		5='Ashe' 6='Avery' 
		7='Beaufort' 8='Bertie' 
		9='Bladen' 10='Brunswick' 
		11='Buncombe' 12='Burke' 
		13='Cabarrus' 14='Caldwell' 
		15='Camden' 16='Carteret' 
		17='Caswell' 18='Catawba' 
		19='Chatham' 20='Cherokee' 
		21='Chowan' 22='Clay' 
		23='Cleveland' 24='Columbus' 
		25='Craven' 26='Cumberland' 
		27='Currituck' 28='Dare' 
		29='Davidson' 30='Davie' 
		31='Duplin' 32='Durham' 
		33='Edgecombe' 34='Forsyth' 
		35='Franklin' 36='Gaston' 
		37='Gates' 38='Graham' 
		39='Granville' 40='Greene' 
		41='Guilford' 42='Halifax' 
		43='Harnett' 44='Haywood' 
		45='Henderson' 46='Hertford' 
		47='Hoke' 48='Hyde' 
		49='Iredell' 50='Jackson' 
		51='Johnston' 52='Jones' 
		53='Lee' 54='Lenoir' 
		55='Lincoln' 56='McDowell' 
		57='Macon' 58='Madison' 
		59='Martin' 60='Mecklenburg' 
		61='Mitchell' 62='Montgomery' 
		63='Moore' 64='Nash' 
		65='New Hanover' 66='Northampton' 
		67='Onslow' 68='Orange' 
		69='Pamlico' 70='Pasquotank' 
		71='Pender' 72='Perquimans' 
		73='Person' 74='Pitt' 
		75='Polk' 76='Randolph' 
		77='Richmond' 78='Robeson' 
		79='Rockingham' 80='Rowan' 
		81='Rutherford' 82='Sampson' 
		83='Scotland' 84='Stanly' 
		85='Stokes' 86='Surry' 
		87='Swain' 88='Transylvania' 
		89='Tyrrell' 90='Union' 
		91='Vance' 92='Wake' 
		93='Warren' 94='Washington' 
		95='Watauga' 96='Wayne' 
		97='Wilkes' 98='Wilson' 
		99='Yadkin' 100='Yancey';
run;


/* change county from numeric to chr */
data county&year(drop=county);
	set c.ds&year;
	length chr_county $20;
	chr_county = put(county, county_.);
	rename chr_county = county;
run;


/* group releases by NC county */
proc sql;
	create table map_release as
	select upcase(county) as county, count(chprs_id) as count_release
	from county&year as a
	group by county;
quit;

/* remerge with 100 counties from NC */
proc sql;
	create table tot_map_release as 
	select * from map_release
	union 
	select distinct(county) from c.nc
	where county not in (select county from map_release);
quit;

/* replace . with 0 */
data tot_map_release;
	set tot_map_release;
	if count_release = . then count_release = 0;
run;

/* display map releases by county */
goptions reset=all border;

proc format;
	value qty_
	other = '0'
	1 = '1'
	2-4 = '2-4'
	5-19 = '5-19'
	20-high = '20+'
	;
run;

title1 "Acute Toxic Releases by County";
title2 "North Carolina: &year.";

/*blue shades*/
pattern1 v=ms c=white; 
pattern2 v=ms c=CXc6dbef; 
pattern3 v=ms c=CX6baed6; 
pattern4 v=ms c=CX08519c; 
pattern5 v=ms c=CX142233;

LEGEND1 LABEL=(HEIGHT=1 POSITION=TOP justify=CENTER "Number of Acute Toxic Releases")
ACROSS=1 DOWN=5 POSITION = (bottom outside left) value=(justify=center)
FRAME
MODE=PROTECT ;


proc gmap
	data=tot_map_release map=c.nc all;
	format count_release qty_.;
	id county;
	choro count_release / 
		discrete legend=legend1 coutline=black levels=all;
run;
quit;

ods pdf close;


