
*********************************************************************
*  Title:         ChPRS annual report generation (Step 2 of 3)         
*                                                                    
*  Description:   Quality checking variables,
*				  generating frequency tables, summary statistics 				  
*                     
*------------------------------------------------------------------- 
*
*  Input:         SAS dataset 
*
*  Output:        PDF of frequency tables, summary statistics
*     
*  Created:       01-31-2025
*
*  Last updated:  02-14-2025
*                                            
********************************************************************;

options orientation=landscape;


/* For %let statements, edit after = */ 

/* Year of report */
%let year = 2022; 

/* Path for library name */
libname c '~/work';

/* Path for PDF file */
ods pdf file="~/work/&year.report_step2.PDF";



ods noproctitle;


title1 "&year. report step 2 of 3";
title2 "Quality checking variables, generating frequency tables, summary statistics ";
ods exclude EngineHost;
proc contents data=c.ds&year;
run;
title;

/*check for missing/invalid values */
/* Incidents freq by category */
%macro freq(var= , format= );

	%if &var=location or &var=county or &var=relstyp or
	&var=sub_typ or &var=sub1 or &var=date or &var=incident_wkday %then %do;
		title "Incidents by &var.";
		proc freq data=c.ds&year nlevels order=freq;
			tables &var / missing list nocum;
			format &var &format;
		run;
		title;
	%end;
	
	%else %do;
		%put error, check other vars; /*note to log*/
    %end;
      
%mend freq;
	
/*Incidents by location*/
%freq(var=location, format=location_.);


/*Incidents by substance1*type*/
title 'Incidents by substance name*type';
proc freq data=c.ds&year nlevels order=freq;
	tables sub1*sub1_oth*sub_typ/ nocum missing list;
	format sub1 sub1_.;
run;
title;

/*Incidents by substance1*substance2*/
title 'Incidents by substance1*substance2*type';
proc freq data=c.ds&year nlevels order=freq;
	tables sub1*sub1_oth*sub2*sub_typ/ nocum missing list;
	format sub1 sub1_. sub2 sub1_.;
run;
title;

/*Incidents by release type*/
%freq(var=relstyp, format=relstyp_.);

/*Incidents by month*/
%freq(var=date, format=monname.);

/*Incidents by weekday*/
%freq(var=incident_wkday, format=weekdate9.);


/*Sort incidents by total injuries */
title 'Incidents by total injuries > 1';
proc sql number;
	select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
	from c.ds&year
	where tot_vict > 1
	order by tot_vict desc; 
quit;
title;

/*Incidents by county*/
%freq(var=county, format=county_.);




/*Sort incidents by total substances */
/*title 'Incidents by total substances > 0';
proc sql number;
	select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	sub1_oth, 
	sub2 format=sub1_.,
	tot_vict, 
	comment
	from c.ds&year
	where tot_chem > 0 or tot_chem is null
	order by tot_chem desc; 
quit;
title;*/



ods pdf close;


