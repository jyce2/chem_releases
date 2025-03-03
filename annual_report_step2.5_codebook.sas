
*********************************************************************
*  Title:         ChPRS annual report generation (Step 2.5 of 3)         
*                                                                    
*  Description:   Quality checking dataset and variables,
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
*  Last updated:  02-28-2025
*                                                                           
********************************************************************;


title1 "&year. report step 2.5 of 3";
title2 "Quality checking dataset and variables, generating frequency tables, summary statistics ";

%LET job=project_codebook_sol;


/* For %let statements, edit after = */ 

/* Year of report */
%let year = 2022; 

/* Path to CSV file */
%let csv_file = '/home/u63543840/work/ChPRSChemicalPrepare-2022Report_DATA_2025-02-28_2124.csv';

/* Path for library name */
libname c '~/work';

/* Path for PDF file */
ods pdf file="~/work/&year.report_step2_codebook.PDF";

OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;

options orientation=portrait;

ods pdf startpage=no;
 ODS NOPTITLE;


%let descwidth=4.0;
%let Nwidth=.5;
%let valwidth=2.0;



%macro mycodebook;

    /***Order variables alphabetically to present an ordered codebook***/
        proc sql noprint;
            select name into :alphalist separated by ' '
                from dictionary.columns
                where libname="C" and memname="DS&year."
                order by name;
        quit;


    %let i=1;
 
    %do %until (%scan(&alphalist,&i)= );
        
        %let var=%scan(&alphalist,&i);


        /***Create a single title at the top of the codebook***/

        %if &var=%scan(&alphalist,1) %then %do;
            title "A codebook for variables in the c.ds&year. dataset";
        %end;
        %else %do; title; %end;


        /***Get variable type and label***/
        data _null_;

            dsid = open("c.ds&year.");
            vtyp = vartype(dsid,varnum(dsid,"&var"));
            vlab = varlabel(dsid,varnum(dsid,"&var"));
            rc = close(dsid);
            
            length fulltype $9;
            if vtyp='N' and (index(upcase(vlab),'DATE'))>0 then fulltype='Date';
            if vtyp='N' and (index(upcase(vlab),'DATE'))=0 then fulltype='Numeric';
            if vtyp='C' then fulltype='Character';
            
            call symput("fulltyp",strip(fulltype));
            call symput("vlabl",strip(vlab));
        
        run;

        /***Procedure for DATE variables***/
        %if &fulltyp = Date %then %do;
            proc sql noprint;
            select count(&var) as c, nmiss(&var), min(&var) format=date9., max(&var) format=date9.
                    INTO :N, :Nmiss, :Minimum, :Maximum 
                from c.ds&year
            order by c desc;
            quit;
        
            
            proc report data=c.ds&year nowd style(header)={just=left};
                columns ("&var." count Value) ("&vlabl." Description);
                define count/computed "N" style={cellwidth=&Nwidth.in};
                define Value/computed style={cellwidth=&valwidth.in};
                define Description/computed 'Summary' style={cellwidth=&descwidth.in just=left};

                compute count;
                count= &N.;
                endcomp;

                compute Value/character length=17;
                Value= "Range";
                endcomp;

                compute Description/character length=50;
                Description= "&minimum. to &maximum. (Missing = %sysfunc(strip(&nmiss.)))";
                endcomp;
            run;
        
        %end;


        /***Procedure for other numeric variables apart from date variables***/
        %if &fulltyp = Numeric %then %do;

            proc sql noprint;
            select count(&var) as c, count(distinct &var) as c2, nmiss(&var), min(&var), max(&var),mean(&var) format = 6.2
                    INTO :N, :distinctN, :Nmiss, :Minimum, :Maximum ,:average
                from c.ds&year
            order by c desc, c2 desc;
            quit;
        
        %if &distinctN >= 15 %then %do;
        proc report data=c.ds&year nowd style(header)={just=left};
            columns ("&var." count Value) ("&vlabl." Description);
            define count/computed "N" style={cellwidth=&Nwidth.in};
            define Value/computed style={cellwidth=&valwidth.in};
            define Description/computed 'Summary' style={cellwidth=&descwidth.in just=left};

            compute count;
            count= &N.;
            endcomp;

            compute Value/character length=17;
            Value= "Range";
            endcomp;

            compute Description/character length=55;
            Description= "%sysfunc(strip(&minimum.)) - %sysfunc(strip(&maximum.)) (Mean = %sysfunc(strip(&average.)), Missing = %sysfunc(strip(&nmiss.)))";
            endcomp;
        run;

        %end;

        %else %if &distinctN < 15 %then %do;

        proc freq data = c.ds&year noprint;
        table &var/
            out = freq_&i;
        run;

        proc report data=freq_&i nowd style(header)={just=left} split="*";
            columns ("&var." count &var.) ("&vlabl." percent);
            define count/display "N" style={cellwidth=&Nwidth.in};
            define &var./display "Value" style={cellwidth=&valwidth.in};
            define percent/display "Percent of Total" style={cellwidth=&descwidth.in just=left} format=6.1;

        run;

        %end;
    
        %end;

        
        /***Procedure for character variables***/
        %if &fulltyp = Character %then %do; 
    
            proc sql noprint;
                select count(&var) as c, nmiss(&var), count(distinct &var)
                        INTO :N, :Nmiss, :unique_var 
                    from c.ds&year
                order by c;
            quit;


        /***Character variables with less unique values***/
        %if &unique_var <=15 %then %do;

            proc freq data = c.ds&year noprint order=freq;
                table &var/
                    out = freqout_&i;
            run;

            proc report data=freqout_&i nowd style(header)={just=left} split="*";
                columns ("&var." count &var.) ("&vlabl." percent);
                define count/display "N" style={cellwidth=&Nwidth.in};
                define &var./display "Value" style={cellwidth=&valwidth.in};
                define percent/display "Percent of Total" style={cellwidth=&descwidth.in just=left} format=6.1;

            run;
        
        %end;

        /***Character variables with several unique values***/
        %else %if &unique_var > 15 %then %do;

            proc report data = c.ds&year nowd style(header)={just=left};
                columns ("&var." count value) ("&vlabl." Description);
                define count/computed "N" style={cellwidth=&Nwidth.in};
                define value/computed "Value" style={cellwidth=&valwidth.in};
                define Description/computed 'Summary' style={cellwidth=&descwidth.in just=left};

                compute count;
                count= &N.;
                endcomp;

                compute value/character length=10;
                value= "ID's";
                endcomp;

                compute Description/character length=50;
                Description= "Unique values = %sysfunc(strip(&unique_var.)), Missing = %sysfunc(strip(&nmiss.))";
                endcomp;
            run;    
        %end; 

        %end;

        %let i=%eval(&i+1);
    %end;
        
    quit;
     

%mend;
%mycodebook;






ods pdf close;