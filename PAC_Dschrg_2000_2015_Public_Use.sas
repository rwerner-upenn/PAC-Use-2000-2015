/************************************************************************************************************************************************************
  PLEASE CITE THIS ARTICLE AS:
 
  Werner RM, Konetzka RT. Trends in Post–Acute Care Use Among Medicare Beneficiaries: 2000 to 2015. JAMA. 2018;319(15):1616–1617. doi:10.1001/jama.2018.2408

************************************************************************************************************************************************************/

/********************************************************************************************************************
* Goal: Create analystical data set for the summary of Post–Acute Care use among Medicare beneficiaries 2000-2015
* Created by: Mingyu Qi
* First created on: 11/14/2017
* Last updated on: 03/28/2019 
********************************************************************************************************************/

/********************************************************
 Step 1 - Generate eligible hospitalization records; 
********************************************************/ 

***Read in acute care hospital stay records from MedPAR claims 2000-2015;
data temp.MedPAR2000_15;
set  Medpar.Mp100mod_2000 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2001 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2002 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2003 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2004 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2005 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2006 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2007 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2008 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2009 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2010 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2011 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2012 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2013 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2014 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) 
     Medpar.Mp100mod_2015 (keep=BENE_ID AGE_CNT SSLSSNF DSCHRGDT SPCLUNIT ADMSNDT DSCHRGCD DSTNTNCD DRG_CD PT_ID PRVDR_NUM SRC_ADMS TYPE_ADM UTIL_DAY) ;
where (substr(PRVDR_NUM,3,1) in ('0','M','R','S','T') or substr(PRVDR_NUM,3,2)="13") & SPCLUNIT not in ('M','R','S','T');
run; *207,126,674 records;

*Limit to records of patients who were discharged alive between Jan 1st 2000 and Dec 28th 2015;
proc sql;
create table temp.MedPAR2000_15_2 as
select * from temp.MedPAR2000_15
where DSCHRGCD eq 'A' & ADMSNDT ge 14610 & DSCHRGDT le 20450;
quit; *199,069,327 records;


***Read in Denominator files (Master Beneficiary Summary Files);
*2000-2006;
data Dn100mod_2000_new;set Denom.Dn100mod_2000(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2000;run;
data Dn100mod_2001_new;set Denom.Dn100mod_2001(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2001;run;
data Dn100mod_2002_new;set Denom.Dn100mod_2002(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2002;run;
data Dn100mod_2003_new;set Denom.Dn100mod_2003(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2003;run;
data Dn100mod_2004_new;set Denom.Dn100mod_2004(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2004;run;
data Dn100mod_2005_new;set Denom.Dn100mod_2005(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2005;run;
data Dn100mod_2006_new;set Denom.Dn100mod_2006(keep=BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND: );RFRNC_YR=2006;run;
data Dn100mod_2000_2006_new;
set  Dn100mod_2000_new Dn100mod_2001_new Dn100mod_2002_new Dn100mod_2003_new Dn100mod_2004_new Dn100mod_2005_new Dn100mod_2006_new;
run; *303,129,340 records;

*Merge Denominator data 2000-2015;
data Denominator2000_15_data;
set  Dn100mod_2000_2006_new 
     Denom.Dn100mod_2007 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2008 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2009 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2010 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2011 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2012 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2013 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2014 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) 
     Denom.Dn100mod_2015 (keep=BENE_ID BENE_DOB DEATH_DT RFRNC_YR SEX RACE HMOIND:) ;
rename  HMOIND01=HMOIND1 HMOIND02=HMOIND2 HMOIND03=HMOIND3 HMOIND04=HMOIND4 HMOIND05=HMOIND5 HMOIND06=HMOIND6 HMOIND07=HMOIND7 HMOIND08=HMOIND8 HMOIND09=HMOIND9;	         
run; *772,091,967 records;

*Change the name of key variables in order to merge files together;
%macro change_name;
%do year=2000 %to 2015;
data temp.Dn100mod_&year.; 
set Denominator2000_15_data; 
where RFRNC_YR=&year and bene_id^=""; 
rename DEATH_DT=DEATH_DT_&year.; 
rename HMOIND1-HMOIND12=HMOIND&year._01-HMOIND&year._12; 
run;

proc sort data=temp.Dn100mod_&year out=temp.Dn100mod_&year._2 nodupkey; by BENE_ID; run; 
%end;
%mend change_name;
%change_name;

*Merge Denominator data 2000-2015 horizontally; 
data temp.Denominator2000_15_data (drop=RFRNC_YR);
merge temp.Dn100mod_2000_2 temp.Dn100mod_2001_2 temp.Dn100mod_2002_2 temp.Dn100mod_2003_2 temp.Dn100mod_2004_2 temp.Dn100mod_2005_2 temp.Dn100mod_2006_2
      temp.Dn100mod_2007_2 temp.Dn100mod_2008_2 temp.Dn100mod_2009_2 temp.Dn100mod_2010_2 temp.Dn100mod_2011_2 temp.Dn100mod_2012_2 temp.Dn100mod_2013_2
      temp.Dn100mod_2014_2 temp.Dn100mod_2015_2;
by BENE_ID;
run; *88,786,566 records in denominator files;

*Find death date for each beneficiary;
data temp.Denominator2000_15_data_2 (drop=DEATH_DT_2010-DEATH_DT_2015);
set temp.Denominator2000_15_data;
DEATH_DT=max(DEATH_DT_2010-DEATH_DT_2015);
run;

data temp.Denominator2000_15_data_2;
retain BENE_ID BENE_DOB DEATH_DT SEX RACE HMOIND2000: HMOIND2001: HMOIND2002: HMOIND2003: HMOIND2004: HMOIND2005: HMOIND2006: HMOIND2007: HMOIND2008: HMOIND2009: HMOIND2010: HMOIND2011:
       HMOIND2012:  HMOIND2013: HMOIND2014: HMOIND2015:;
format death_dt date9.;
set temp.Denominator2000_15_data_2;
run;


***Merge hospitalization records and Denominator data together;
proc sql;
create table temp.Merged2000_15 as
select medpar.*,denom.* 
from temp.MedPAR2000_15_2 as medpar
left join temp.Denominator2000_15_data_2 as denom
on medpar.BENE_ID=denom.BENE_ID;
quit; *199,069,327 records;


***Exclude records of patients who were younger than 65 on admission or discharged to hospice;
data temp.Merged2000_15;
set temp.Merged2000_15;
age_adm=floor((intck('month',BENE_DOB,ADMSNDT)-(day(ADMSNDT)<day(BENE_DOB)))/12);
run;

data temp.Merged2000_15_2;
set temp.Merged2000_15;
dschrg_year=year(DSCHRGDT);
dschrg_month=month(DSCHRGDT);
if DSTNTNCD in (41,42,50,51) then hospice=1;
else if DSTNTNCD not in (41,42,50,51) and DSTNTNCD ne . then  hospice=0;
else hospice=.;
where age_adm ge 65 and DSTNTNCD not in (41,42,50,51); 
run; *160,033,003;

*Limit the records to those who were not in HMO on discharge;
%macro HMO;
data temp.Merged2000_15_3;
set temp.Merged2000_15_2;
%do i=2000 %to 2015;
if dschrg_year=i then do;
if dschrg_month=1 and HMOIND&i._01 in (' ','0','4') then discharge_elig=1; 
else if dschrg_month=2 and HMOIND&i._02 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=3 and HMOIND&i._03 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=4 and HMOIND&i._04 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=5 and HMOIND&i._05 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=6 and HMOIND&i._06 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=7 and HMOIND&i._07 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=8 and HMOIND&i._08 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=9 and HMOIND&i._09 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=10 and HMOIND&i._10 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=11 and HMOIND&i._11 in (' ','0','4') then discharge_elig=1;
else if dschrg_month=12 and HMOIND&i._12 in (' ','0','4') then discharge_elig=1;
end;
%end;
run;
%mend HMO;
%HMO; 

data temp.Merged2000_15_4 (drop=HMOIND2000: HMOIND2001: HMOIND2002: HMOIND2003: HMOIND2004: HMOIND2005: HMOIND2006: HMOIND2007: HMOIND2008: HMOIND2009: HMOIND2010: HMOIND2011:
       HMOIND2012:  HMOIND2013: HMOIND2014: HMOIND2015:);
set temp.Merged2000_15_3;
where discharge_elig=1;
run; *139,814,729 records; 

proc sort data=temp.Merged2000_15_4; by BENE_ID DSCHRGDT; run;

data temp.Merged2000_15_5;
set temp.Merged2000_15_4;
by BENE_ID DSCHRGDT;
if first.DSCHRGDT then output;
run; *139,782,151 records;  



/********************************************************
 Step 2 - Generate SNF, IRF and other PAC cohorts; 
********************************************************/

***Read SNF data from MedPAR data 2000-2015;
proc sql;
create table MedPAR2000_15_SNF as
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2000(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2001(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2002(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2003(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2004(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2005(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2006(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2007(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2008(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2009(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2010(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2011(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2012(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF)) 
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2013(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF))
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2014(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF))
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') union all
select BENE_ID, ADMSNDT_SNF, DSCHRGDT_SNF, LOSCNT, PMT_AMT_SNF, PRVDR_NUM, UTIL_DAY from Medpar.Mp100mod_2015(rename=(ADMSNDT=ADMSNDT_SNF DSCHRGDT=DSCHRGDT_SNF PMT_AMT=PMT_AMT_SNF))
where substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z')
order by BENE_ID, ADMSNDT_SNF;
quit; *38,856,911 records;

data MedPAR2000_15_SNF_2;
set MedPAR2000_15_SNF;
by BENE_ID ADMSNDT_SNF;
if first.ADMSNDT_SNF then output;
run; *38,819,355 records;

data temp.MedPAR2000_15_SNF_unique;
set MedPAR2000_15_SNF_2;
DSCHRGDT_SNF_pseudo=DSCHRGDT_SNF;
* If the discharge date is missing, then we generate pseudo discharge date, which equals to the admission date plus length of stay;
if DSCHRGDT_SNF eq . then DSCHRGDT_SNF_pseudo=ADMSNDT_SNF+LOSCNT;
run;

	
***Read IRF data from MedPAR data 2000-2015;
proc sql;
create table MedPAR2000_15_IRF as
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2000(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2001(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2002(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2003(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2004(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2005(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2006(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2007(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2008(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2009(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2010(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2011(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2012(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF)) 
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2013(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF))
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2014(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF))
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099")	union all
select BENE_ID, ADMSNDT_IRF, DSCHRGDT_IRF, PMT_AMT_IRF, PRVDR_NUM, SPCLUNIT, UTIL_DAY from Medpar.Mp100mod_2015(rename=(ADMSNDT=ADMSNDT_IRF DSCHRGDT=DSCHRGDT_IRF PMT_AMT=PMT_AMT_IRF))
where SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099")
order by BENE_ID, ADMSNDT_IRF;
quit; *6,963,942 records;

data temp.MedPAR2000_15_IRF_unique;
set MedPAR2000_15_IRF;
by BENE_ID ADMSNDT_IRF;
if first.ADMSNDT_IRF then output;
run; *6,960,669 unique records for IRF - no need to generate pseudo discharge date for IRF because there is no missing;


***Read all other post-acute care data from MedPAR data 2000-2015;
%macro other;
%do year=2000 %to 2015;
data medpar&year.;
	set Medpar.Mp100mod_&year.;
	if (substr(PRVDR_NUM,3,1) in ('0','M','R','S','T') or 1300<=substr(PRVDR_NUM,3,4)<=1399) & SPCLUNIT not in ('M','R','S','T') then type=0;
		else if substr(PRVDR_NUM,3,1) in ('5','6','U','W','Y','Z') then type=1;
		else if SPCLUNIT in ('R','T') or ("3025"<=substr(prvdr_num,3,4)<="3099") then type=2;
		else type=4;
	keep BENE_ID ADMSNDT DSCHRGDT PRVDR_NUM PMT_AMT type UTIL_DAY;
run;
%mend other;
%other;

proc sql;
create table medpar2000_15_other as
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2000 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2001 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2002 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2003 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2004 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2005 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2006 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2007 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2008 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2009 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2010 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2011 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2012 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2013 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2014 where type eq 4 union all
select BENE_ID, ADMSNDT as ADMSNDT_other, DSCHRGDT as DSCHRGDT_other, PRVDR_NUM as other_PRVDRNUM, PMT_AMT as PMT_AMT_other, UTIL_DAY as UTIL_DAY_other
from medpar2015 where type eq 4 ;
quit; *9,646,186 records;

proc sort data=medpar2000_15_other; by BENE_ID ADMSNDT_other; run; 

data temp.other2000_15_unique;
set medpar2000_15_other;
by BENE_ID ADMSNDT_other;
if first.ADMSNDT_other then output;
run; *9,639,551 records; 



/***********************************************************
 Step 3 - Combine hospitalization records with PAC records; 
***********************************************************/

***Merge SNF, IRF and HHA data with hospital data;
proc sql;
create table temp.merge_all_2000_15 as
select distinct main.*, snf.ADMSNDT_SNF, snf.DSCHRGDT_SNF_pseudo, snf.PRVDR_NUM as SNF_PRVDRNUM, snf.UTIL_DAY as UTIL_DAY_SNF, irf.ADMSNDT_IRF, irf.DSCHRGDT_IRF, irf.PRVDR_NUM as IRF_PRVDRNUM, irf.UTIL_DAY as UTIL_DAY_IRF,
       other.other_PRVDRNUM, other.ADMSNDT_other, other.DSCHRGDT_other
from temp.Merged2000_15_5(rename=(PRVDR_NUM=HOSP_PRVDRNUM)) as main
left join temp.MedPAR2000_15_SNF_unique as snf on main.BENE_ID=snf.BENE_ID
left join temp.MedPAR2000_15_IRF_unique as irf on main.BENE_ID=irf.BENE_ID
left join temp.other2000_15_unique as other on main.BENE_ID=other.BENE_ID;
quit; *444,379,461 records;

*Patients should be sent to post-acute care instutitions within 3 days after the hospital discharge date; 
data temp.merge_all_2000_15_2;
set temp.merge_all_2000_15;
if 0 le ADMSNDT_SNF-DSCHRGDT le 3 then gap_snf=ADMSNDT_SNF-DSCHRGDT; else gap_snf=.;
if 0 le ADMSNDT_IRF-DSCHRGDT le 3 then gap_irf=ADMSNDT_IRF-DSCHRGDT; else gap_irf=.;
if 0 le ADMSNDT_other-DSCHRGDT le 3 then gap_other=ADMSNDT_other-DSCHRGDT; else gap_other=.;
if gap_snf ne . | gap_irf ne . | gap_other ne . then do;
    if min(gap_snf, gap_irf, gap_other) eq gap_other then do; disch_pac_n=4; gap=gap_other; end;
	if min(gap_snf, gap_irf, gap_other) eq gap_irf then do; disch_pac_n=2; gap=gap_irf; end;
	if min(gap_snf, gap_irf, gap_other) eq gap_snf then do; disch_pac_n=1; gap=gap_snf; end;
end;
if gap eq . then gap=99;
run; 

proc sort data=temp.merge_all_2000_15_2; by BENE_ID DSCHRGDT gap; run;

data temp.merge_all_2000_15_3;
set temp.merge_all_2000_15_2;
by BENE_ID DSCHRGDT gap;
if first.DSCHRGDT then output;
run; *139,782,151 records;

data temp.merge_all_2000_15_4;
set temp.merge_all_2000_15_3;
if disch_pac_n eq 1 then do; DSCHRGDT_SNF_pseudo=ADMSNDT_SNF+UTIL_DAY_snf; PAC_DSCHRGDT=ADMSNDT_SNF+UTIL_DAY_snf; PAC_ADMSNDT=ADMSNDT_SNF; end;
else if disch_pac_n eq 2 then do; PAC_DSCHRGDT=DSCHRGDT_IRF; PAC_ADMSNDT=ADMSNDT_IRF; end;
else if disch_pac_n eq 4 then do; PAC_DSCHRGDT=DSCHRGDT_other; PAC_ADMSNDT=ADMSNDT_other; end;
if disch_pac_n eq . then disch_pac_n=0;
Hosp_Days=DSCHRGDT-ADMSNDT+1;
format disch_pac_n pacf_n.;
rename UTIL_DAY=Hosp_Days_All;
run;

data PAC.merge_all_2000_15;
set temp.merge_all_2000_15_4;
if disch_pac_n eq 1 then PAC_Days_All=UTIL_DAY_snf;
else if disch_pac_n in (2,4) then Pac_Days_All=PAC_DSCHRGDT-PAC_ADMSNDT+1;
if disch_pac_n eq . then PAC_Days_All=.;
Hosp_PAC_Days_All=Hosp_Days_All+Pac_Days_All;
label Hosp_PAC_Days_All="Total Number of Days in the Hospital and PAC Episode" 
      PAC_Days_All="Total Number of Days in the PAC Episode" 
      Hosp_Days_All="Number of Days in the Hospital"
      Hosp_Days="Length of Hospital Stay between Admission and Discharge";
run; *139,782,151 records;
proc sort data=tempn.DGNS_2000_2015 out=check_dup nodupkey; by BENE_ID DSCHRGDT ADMSNDT HOSP_PRVDRNUM; run; 
*0 duplicate - Provider number, admission data, discharge date and bene_id could be used to identify unique record;



/***********************************************************
 Step 4 - Create Elixhauser Comorbidity Index Variables; 
***********************************************************/

*Create a data set to store the first 10 diagnosis codes of each claim;
data tempn.DGNS_2000_2015;
set  Medpar.Mp100mod_2000 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2001 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2002 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2003 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2004 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2005 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2006 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2007 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2008 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2009 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2010 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2011 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2012 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2013 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
	 Medpar.Mp100mod_2014 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10)
     Medpar.Mp100mod_2015 (keep=BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM SPCLUNIT DGNS_CD01-DGNS_CD10);
where (substr(PRVDR_NUM,3,1) in ('0','M','R','S','T') or substr(PRVDR_NUM,3,2)="13") & SPCLUNIT not in ('M','R','S','T');
run; *207,126,674 records;

*Check if "BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM" could be used as unique key for merging;
proc sort data=tempn.DGNS_2000_2015 nodupkey; by BENE_ID DSCHRGDT ADMSNDT PRVDR_NUM; run; *9,055 duplicates - less than 0.01%;

*Merge 10 diagnosis codes into analytical data set;
proc sql;
create table tempn.merge_all_0015_dgns as 
select a.*, b.DGNS_CD01, b.DGNS_CD02, b.DGNS_CD03, b.DGNS_CD04, b.DGNS_CD05, b.DGNS_CD06, b.DGNS_CD07, b.DGNS_CD08, b.DGNS_CD09, b.DGNS_CD10 
from PAC.merge_all_2000_15 as a left join tempn.DGNS_2000_2015 as b
on a.hosp_prvdrnum=b.prvdr_num and a.bene_id=b.bene_id and a.dschrgdt=b.dschrgdt and a.admsndt=b.admsndt;
quit; *139,782,151 records; 

*Separate the data set by whether using ICD-10 - ICD-10 has been used for diagnosis code starting from October 2015;
data tempn.merge_all_0015_dgns_ICD9 tempn.merge_all_0015_dgns_ICD10;
set tempn.merge_all_0015_dgns;
if dschrg_year=2015 and dschrg_month in (10,11,12) then output tempn.merge_all_0015_dgns_ICD10; *1,778,971;
else output tempn.merge_all_0015_dgns_ICD9; *138,003,180;
run;

*Use SAS Macro developed by Manitoba Center for Health Policy to create the 31 comorbidity index;
*Reference: http://mchp-appserv.cpe.umanitoba.ca/viewConcept.php?conceptID=1436;

/*ICD-9 */
%macro _ElixhauserICD9CM (DATA    =,   /* input data set */
                           OUT    =,   /* output data set */
                           dx     =,  /* range of diagnosis variables */
                           dxtype =, /* range of diagnosis type variables */           
                           type   =, /** turn the use of dxtype on or off **/
                           debug  = ) ;

	%let debug = %lowcase(&debug) ;
	%let type = %lowcase(&type) ;

	%* put default options into &opts variable ;
  %let opts=%sysfunc(getoption(mprint,keyword))
	  %sysfunc(getoption(notes,keyword)) ;
  %if &debug=1 | &debug=debug %then %do ;
		options mprint notes ;
		%end ;
	%else %do ;
		options nomprint nonotes ;
		%end ;
	
	%* Check if previous data step, or procdure had an error and
	 stop running the rates macro
	This assumes that the previous step is used in the macro.;
 %if %eval(&SYSERR>0) %then %goto out1 ; 
  
  %* Check if input data exists ;
  %if &data= %str() %then %goto out2 ;
  
  %* if the output data set is not defined then define it as the input ;
  %if &out=  %then %let out=&data ;
  
  %if %index(&data,.) %then %do;
     %let libname=%scan(&data,1);
	 %let data=%scan(&data,2);
	 %end;
 %else %do ;
	 %let libname=work ;
	 %let data=&data ;
	 %end ;
 
 %if %sysfunc(exist(&libname..&data)) ^= 1 %then %goto out3 ;
 

   data &OUT;
   set &DATA ;

   /*  set up array for individual ELX group counters */
   array ELX_GRP (31) ELX_GRP_1 - ELX_GRP_31;

   /*  set up array for each diagnosis code within a record */
   array DX (*) &dx;

   /*  set up array for each diagnosis type code within a record */
   %if &type=on %then array DXTYP (*) &dxtype; ;
   

   /*  initialize all ELX group counters to zero */
   do i = 1 to 31;
      ELX_GRP(i) = 0;
   end;

   /*  check each patient record for the diagnosis codes in each ELX group. */
   do i = 1 to dim(dx) UNTIL (DX(i)=' ');   /* for each set of diagnoses codes */

   /*  skip diagnosis if diagnosis type = "C" */

      %if &type=on %then if DXTYP(i) ^= 'C' then DO; ;         /* identify Elixhauser groupings */

         /* Congestive Heart Failure */
         if  Dx(i) IN: ('39891','40201','40211','40291','40401','40403','40411','40413','40491',
                 '40493','4254','4255','4257','4258','4259','428') then ELX_GRP_1 = 1;
            LABEL ELX_GRP_1='Congestive Heart Failure';

         /* Cardiac Arrhythmia */
         if  Dx(i) IN: ('4260','42613','4267','4269','42610','42612','4270','4271','4272','4273',
                 '4274','4276','4278','4279','7850','99601','99604','V450','V533') then ELX_GRP_2 = 1;
            LABEL ELX_GRP_2='Cardiac Arrhythmia';

         /* Valvular Disease */
         if  Dx(i) IN: ('0932','394','395','396','397','424','7463','7464','7465','7466','V422','V433')
                  then ELX_GRP_3 = 1;
            LABEL ELX_GRP_3='Valvular Disease';

         /* Pulmonary Circulation Disorders */
         if  Dx(i) IN: ('4150','4151','416','4170','4178','4179') then ELX_GRP_4 = 1;
            LABEL ELX_GRP_4='Pulmonary Circulation Disorders';

         /* Peripheral Vascular Disorders */
         if  Dx(i) IN: ('0930','4373','440','441','4431','4432','4438','4439','4471','5571','5579','V434')
                  then ELX_GRP_5 = 1;
            LABEL ELX_GRP_5='Peripheral Vascular Disorders';

         /* Hypertension Uncomplicated */
         if  Dx(i) IN: ('401') then ELX_GRP_6 = 1;
            LABEL ELX_GRP_6='Hypertension Uncomplicated';

         /* Hypertension Complicated */
         if  Dx(i) IN: ('402','403','404','405') then ELX_GRP_7 = 1;
            LABEL ELX_GRP_7='Hypertension Complicated';

         /* Paralysis */
         if  Dx(i) IN: ('3341','342','343','3440','3441','3442','3443','3444','3445','3446','3449')
                  then ELX_GRP_8 = 1;
           LABEL ELX_GRP_8='Paralysis';

         /* Other Neurological Disorders */
         if  Dx(i) IN: ('3319','3320','3321','3334','3335','33392','334','335','3362','340','341',
                  '345','3481','3483','7803','7843') then ELX_GRP_9 = 1;
           LABEL ELX_GRP_9='Other Neurological Disorders';

         /* Chronic Pulmonary Disease */
         if  Dx(i) IN: ('4168','4169','490','491','492','493','494','495','496','500','501','502',
                  '503','504','505','5064','5081','5088') then ELX_GRP_10 = 1;
           LABEL ELX_GRP_10='Chronic Pulmonary Disease';

         /* Diabetes Uncomplicated */
         if  Dx(i) IN: ('2500','2501','2502','2503') then ELX_GRP_11 = 1;
           LABEL ELX_GRP_11='Diabetes Uncomplicated';

         /* Diabetes Complicated */
         if  Dx(i) IN: ('2504','2505','2506','2507','2508','2509') then ELX_GRP_12 = 1;
           LABEL ELX_GRP_12='Diabetes Complicated';

         /* Hypothyroidism */
         if  Dx(i) IN: ('2409','243','244','2461','2468') then ELX_GRP_13 = 1;
           LABEL ELX_GRP_13='Hypothyroidism';

         /* Renal Failure */
         if  Dx(i) IN: ('40301','40311','40391','40402','40403','40412','40413','40492','40493',
                  '585','586','5880','V420','V451','V56') then ELX_GRP_14 = 1;
           LABEL ELX_GRP_14='Renal Failure';

         /* Liver Disease */
         if  Dx(i) IN: ('07022','07023','07032','07033','07044','07054','0706','0709','4560','4561',
                  '4562','570','571','5722','5723','5724','5728','5733','5734','5738','5739','V427')
                  then ELX_GRP_15 = 1;
           LABEL ELX_GRP_15='Liver Disease';

         /* Peptic Ulcer Disease excluding bleeding */
         if  Dx(i) IN: ('5317','5319','5327','5329','5337','5339','5347','5349')
                  then ELX_GRP_16 = 1;
           LABEL ELX_GRP_16='Peptic Ulcer Disease excluding bleeding';

         /* AIDS/HIV */
         if  Dx(i) IN: ('042','043','044')  then ELX_GRP_17 = 1;
           LABEL ELX_GRP_17='AIDS/HIV';

         /* Lymphoma */
         if  Dx(i) IN: ('200','201','202','2030','2386') then ELX_GRP_18 = 1;
           LABEL ELX_GRP_18='Lymphoma';

         /* Metastatic Cancer */
         if  Dx(i) IN: ('196','197','198','199') then ELX_GRP_19 = 1;
           LABEL ELX_GRP_19='Metastatic Cancer';

         /* Solid Tumor without Metastasis */
         if  Dx(i) IN: ('140','141','142','143','144','145','146','147','148','149','150','151','152',
                  '153','154','155','156','157','158','159','160','161','162','163','164','165','166','167',
                  '168','169','170','171','172','174','175','176','177','178','179','180','181','182','183',
                  '184','185','186','187','188','189','190','191','192','193','194','195')
                  then ELX_GRP_20 = 1;
           LABEL ELX_GRP_20='Solid Tumor without Metastasis';

         /* Rheumatoid Arthritis/collagen */
         if  Dx(i) IN: ('446','7010','7100','7101','7102','7103','7104','7108','7109','7112','714',
                  '7193','720','725','7285','72889','72930') then ELX_GRP_21 = 1;
           LABEL ELX_GRP_21='Rheumatoid Arthritis/collagen';

         /* Coagulopathy */
         if  Dx(i) IN: ('286','2871','2873','2874','2875')  then ELX_GRP_22 = 1;
           LABEL ELX_GRP_22='Coagulopathy';

         /* Obesity */
         if  Dx(i) IN: ('2780') then ELX_GRP_23 = 1;
           LABEL ELX_GRP_23='Obesity';

         /* Weight Loss */
         if  Dx(i) IN: ('260','261','262','263','7832','7994') then ELX_GRP_24 = 1;
           LABEL ELX_GRP_24='Weight Loss';

         /* Fluid and Electrolyte Disorders */
         if  Dx(i) IN: ('2536','276') then ELX_GRP_25 = 1;
           LABEL ELX_GRP_25='Fluid and Electrolyte Disorders';

         /* Blood Loss Anemia */
         if  Dx(i) IN: ('2800') then ELX_GRP_26 = 1;
           LABEL ELX_GRP_26='Blood Loss Anemia';

         /* Deficiency Anemia */
         if  Dx(i) IN: ('2801','2808','2809','281') then ELX_GRP_27 = 1;
           LABEL ELX_GRP_27='Deficiency Anemia';

         /* Alcohol Abuse */
         if  Dx(i) IN: ('2652','2911','2912','2913','2915','2918','2919','3030','3039','3050',
                  '3575','4255','5353','5710','5711','5712','5713','980','V113') then ELX_GRP_28 = 1;
           LABEL ELX_GRP_28='Alcohol Abuse';

         /* Drug Abuse */
         if  Dx(i) IN: ('292','304','3052','3053','3054','3055','3056','3057','3058','3059','V6542')
                  then ELX_GRP_29 = 1;
           LABEL ELX_GRP_29='Drug Abuse';

         /* Psychoses */
         if  Dx(i) IN: ('2938','295','29604','29614','29644','29654','297','298')
                  then ELX_GRP_30 = 1;
           LABEL ELX_GRP_30='Psychoses';

         /* Depression */
         if  Dx(i) IN: ('2962','2963','2965','3004','309','311') then ELX_GRP_31 = 1;
           LABEL ELX_GRP_31='Depression';
	  %if &type=on %then end; ;
		   
   end;

   TOT_GRP = ELX_GRP_1  + ELX_GRP_2  +  ELX_GRP_3  +  ELX_GRP_4  +  ELX_GRP_5  +  ELX_GRP_6  +  ELX_GRP_7  +
             ELX_GRP_8  + ELX_GRP_9  +  ELX_GRP_10 +  ELX_GRP_11 +  ELX_GRP_12 +  ELX_GRP_13 +  ELX_GRP_14 +
             ELX_GRP_15 + ELX_GRP_16 +  ELX_GRP_17 +  ELX_GRP_18 +  ELX_GRP_19 +  ELX_GRP_20 +  ELX_GRP_21 +
             ELX_GRP_22 + ELX_GRP_23 +  ELX_GRP_24 +  ELX_GRP_25 +  ELX_GRP_26 +  ELX_GRP_27 +  ELX_GRP_28 +
             ELX_GRP_29 + ELX_GRP_30 +  ELX_GRP_31;
     LABEL TOT_GRP ='Total Elixhauser Groups per record';

	run;
    
	options notes ;
	 %put ;
	 %put NOTE: _Charlson Finished &out created ;
     %put ;	

	%goto exit ;
	
    %out1:
		%put ERROR: Prior Step failed with an Error submit a null data step to correct ;
	%goto exit ;

	%out2:
		%put ERROR: Input Data Was Not Defined;
	%goto exit ;

    %out3:
        %put ERROR: Input Data &libname..&data does not exist ;
        %goto exit ;	

    %exit:
	
     %**** Reset the SAS options ;
     options &opts ; 

%mend _ElixhauserICD9CM;

*Create a temp file for calling macro;
data merge_all_0015_dgns_ICD9;
   set tempn.merge_all_0015_dgns_ICD9;
run;

*Call macro;
   %_ElixhauserICD9CM (DATA    =merge_all_0015_dgns_ICD9,
                       OUT     =tempn.merge_all_0015_dgns_ICD9_2 ,
                       dx      =DGNS_CD01-DGNS_CD10,
                       dxtype  =,
                       type    =off, 
                       debug   =off ) ;					   
run;


/*ICD-10*/
%macro _ElixhauserICD10 (DATA      =,    /* input data set */
                         OUT =,    /* output data set */
                         dx =,  /* range of diagnosis variables (diag01-diag25) */
                         dxtype = ,   /* range of diagnosis type variables 
                                          (diagtype01-diagtype25) */
                         type= , /** turn the use of dxtype on or off **/
							 debug = ) ;

	%let debug = %lowcase(&debug) ;
	%let type = %lowcase(&type) ;

	%* put default options into &opts variable ;
  %let opts=%sysfunc(getoption(mprint,keyword))
	  %sysfunc(getoption(notes,keyword)) ;
  %if &debug=1 | &debug=debug %then %do ;
		options mprint notes ;
		%end ;
	%else %do ;
		options nomprint nonotes ;
		%end ;
	
	%* Check if previous data step, or procdure had an error and
	 stop running the rates macro
	This assumes that the previous step is used in the macro.;
 %if %eval(&SYSERR>0) %then %goto out1 ; 
  
  %* Check if input data exists ;
  %if &data= %str() %then %goto out2 ;
  
  %* if the output data set is not defined then define it as the input ;
  %if &out=  %then %let out=&data ;
  
  %if %index(&data,.) %then %do;
     %let libname=%scan(&data,1);
	 %let data=%scan(&data,2);
	 %end;
 %else %do ;
	 %let libname=work ;
	 %let data=&data ;
	 %end ;
 
 %if %sysfunc(exist(&libname..&data)) ^= 1 %then %goto out3 ;

    data &OUT;
    set &DATA  ;

    /*  set up array for individual ELX group counters */
    array ELX_GRP (31) ELX_GRP_1 - ELX_GRP_31;

    /*  set up array for each diagnosis code within a record */
    array DX (*) &dx;

    /*  set up array for each diagnosis type code within a record */
	%if &type=on %then array DXTYP (*) &dxtype; ;

    /*  initialize all ELX group counters to zero */
    do i = 1 to 31;
       ELX_GRP(i) = 0;
    end;

    /*  check each set of diagnoses codes for each ELX group. */

    do i = 1 to dim(dx) UNTIL (DX(i)=' ');   /* for each set of diagnoses codes */

    /*  skip diagnosis if diagnosis type = "2" */

         %if &type=on %then if DXTYP(i) ^= '2' then DO; ;   /* identify ELX group */

          /* Congestive Heart Failure */
          if  DX(i) IN:  ('I099','I110','I130','I132','I255','I420','I425','I426','I427','I428',
                          'I429','I43','I50','P290') then ELX_GRP_1 = 1;
            LABEL ELX_GRP_1 = 'Congestive Heart Failure';


          /*Caridiac Arrhythmia*/
          if  DX(i) IN:  ('I441','I442','I443','I456','I459','I47','I48','I49','R000','R001',
                          'R008','T821','Z450','Z950') then ELX_GRP_2 = 1;
            LABEL ELX_GRP_2 = 'Caridiac Arrhythmia';

          /*Valvular Disease*/
          if  DX(i) IN:  ('A520','I05','I06','I07','I08','I091','I098','I34','I35','I36','I37',
                          'I38','I39','Q230','Q231','Q232','Q233','Z952','Z953','Z954')
                          then ELX_GRP_3 = 1;
            LABEL ELX_GRP_3 = 'Valvular Disease';

          /*Pulmonary Circulation Disorders*/
          if  DX(i) IN:  ('I26','I27','I280','I288','I289') then ELX_GRP_4 = 1;
            LABEL ELX_GRP_4 = 'Pulmonary Circulation Disorders';

          /*Peripheral Vascular Disorders*/
          if  DX(i) IN:  ('I70','I71','I731','I738','I739','I771','I790','I792','K551','K558',
                          'K559','Z958','Z959') then ELX_GRP_5 = 1;
            LABEL ELX_GRP_5 = 'Peripheral Vascular Disorders';

          /*Hypertension Uncomlicated*/
          if  DX(i) IN:  ('I10') then ELX_GRP_6 = 1;
            LABEL ELX_GRP_6 = 'Hypertension Uncomplicated';

          /*Hypertension comlicated*/
          if  DX(i) IN:  ('I11','I12','I13','I15') then ELX_GRP_7 = 1;
            LABEL ELX_GRP_7 ='Hypertension Complicated';

          /*Paralysis*/
          if  DX(i) IN:  ('G041','G114','G801','G802','G81','G82','G830','G831','G832','G833',
                          'G834','G839') then ELX_GRP_8 = 1;
            LABEL ELX_GRP_8 = 'Paralysis';

          /* Other Neurological Disorders*/
          if  DX(i) IN:  ('G10','G11','G12','G13','G20','G21','G22','G254','G255','G312','G318',
                          'G319','G32','G35','G36','G37','G40','G41','G931','G934','R470','R56')
                          then ELX_GRP_9 = 1;
            LABEL ELX_GRP_9 = 'Other Neurological Disorders';

          /*Chronic Pulmonary Disease*/
          if  DX(i) IN:  ('I278','I279','J40','J41','J42','J43','J44','J45','J46','J47','J60','J61',
                          'J62','J63','J64','J65','J66','J67','J684','J701','J703')
                          then ELX_GRP_10 = 1;
            LABEL ELX_GRP_10 = 'Chronic Pulmonary Disease';

          /*Diabetes Uncomplicated*/
          if  DX(i) IN:  ('E100','E101','E109','E110','E111','E119','E120','E121','E129','E130',
                          'E131','E139','E140','E141','E149') then ELX_GRP_11 = 1;
            LABEL ELX_GRP_11 = 'Diabetes Uncomplicated';

          /*Diabetes Complicated*/
          if  DX(i) IN:  ('E102','E103','E104','E105','E106','E107','E108','E112','E113','E114','E115',
                          'E116','E117','E118','E122','E123','E124','E125','E126','E127','E128','E132',
                          'E133','E134','E135','E136','E137','E138','E142','E143','E144','E145','E146',
                          'E147','E148') then ELX_GRP_12 = 1;
            LABEL ELX_GRP_12 = 'Diabetes Complicated';

          /*Hypothyroidism*/
          if  DX(i) IN:  ('E00','E01','E02','E03','E890') then ELX_GRP_13 = 1;
            LABEL ELX_GRP_13 = 'Hypothyroidism';

          /*Renal Failure*/
          if  DX(i) IN:  ('I120','I131','N18','N19','N250','Z490','Z491','Z492','Z940','Z992')
                          then ELX_GRP_14 = 1;
            LABEL ELX_GRP_14 = 'Renal Failure';

          /*Liver Disease*/
          if  DX(i) IN:  ('B18','I85','I864','I982','K70','K711','K713','K714','K715','K717','K72','K73',
                          'K74','K760','K762','K763','K764','K765','K766','K767','K768','K769','Z944')
                          then ELX_GRP_15 = 1;
            LABEL ELX_GRP_15 = 'Liver Disease';

          /*Peptic Ulcer Disease excluding bleeding*/
          if  DX(i) IN:  ('K257','K259','K267','K269','K277','K279','K287','K289') then ELX_GRP_16 = 1;
            LABEL ELX_GRP_16 = 'Peptic Ulcer Disease excluding bleeding';

          /*AIDS/HIV*/
          if  DX(i) IN:  ('B20','B21','B22','B24') then ELX_GRP_17 = 1;
            LABEL ELX_GRP_17 = 'AIDS/HIV';

          /*Lymphoma*/
          if  DX(i) IN:  ('C81','C82','C83','C84','C85','C88','C96','C900','C902') then ELX_GRP_18 = 1;
            LABEL ELX_GRP_18 = 'Lymphoma';

          /*Metastatic Cancer*/
          if  DX(i) IN:  ('C77','C78','C79','C80') then ELX_GRP_19 = 1;
            LABEL ELX_GRP_19 ='Metastatic Cancer';

          /*Solid Tumor without Metastasis*/
          if  DX(i) IN:  ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13',
                          'C14','C15','C16','C17','C18','C19','C20','C21','C22','C23','C24','C25','C26','C30',
                          'C31','C32','C33','C34','C37','C38','C39','C40','C41','C43','C45','C46','C47','C48',
                          'C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63',
                          'C64','C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C97')
                          then ELX_GRP_20 = 1;
            LABEL ELX_GRP_20 = 'Solid Tumor without Metastasis';

          /*Rheumatoid Arthritis/collagen*/
          if  DX(i) IN:  ('L940','L941','L943','M05','M06','M08','M120','M123','M30','M310','M311','M312','M313',
                          'M32','M33','M34','M35','M45','M461','M468','M469') then ELX_GRP_21 = 1;
            LABEL ELX_GRP_21 = 'Rheumatoid Arthritis/collagen';

          /*Coagulopathy*/
          if  DX(i) IN:  ('D65','D66','D67','D68','D691','D693','D694','D695','D696') then ELX_GRP_22 = 1;
            LABEL ELX_GRP_22 = 'Coagulopathy';

          /*Obesity*/
          if  DX(i) IN:  ('E66') then ELX_GRP_23 = 1;
            LABEL ELX_GRP_23 = 'Obesity';

          /*Weight Loss*/
          if  DX(i) IN:  ('E40','E41','E42','E43','E44','E45','E46','R634','R64') then ELX_GRP_24 = 1;
            LABEL ELX_GRP_24 = 'Weight Loss';

          /*Fluid and Electrolyte Disorders*/
          if  DX(i) IN:  ('E222','E86','E87') then ELX_GRP_25 = 1;
            LABEL ELX_GRP_25 = 'Fluid and Electrolyte Disorders';

          /*Blood Loss Anemia*/
          if  DX(i) IN:  ('D500') then ELX_GRP_26 = 1;
            LABEL ELX_GRP_26 = 'Blood Loss Anemia';

          /*Deficiency Anemia*/
          if  DX(i) IN:  ('D508','D509','D51','D52','D53') then ELX_GRP_27 = 1;
            LABEL ELX_GRP_27 = 'Deficiency Anemia';

          /*Alcohol Abuse*/
          if  DX(i) IN:  ('F10','E52','G621','I426','K292','K700','K703','K709','T51','Z502','Z714','Z721')
                          then ELX_GRP_28 = 1;
            LABEL ELX_GRP_28 = 'Alcohol Abuse';

          /*Drug Abuse*/
          if  DX(i) IN:  ('F11','F12','F13','F14','F15','F16','F18','F19','Z715','Z722') then ELX_GRP_29 = 1;
            LABEL ELX_GRP_29 = 'Drug Abuse';

          /*Psychoses*/
          if  DX(i) IN:  ('F20','F22','F23','F24','F25','F28','F29','F302','F312','F315') then ELX_GRP_30 = 1;
            LABEL ELX_GRP_30 = 'Psychoses';

          /*Depression*/
          if  DX(i) IN:  ('F204','F313','F314','F315','F32','F33','F341','F412','F432') then ELX_GRP_31 = 1;
            LABEL ELX_GRP_31 = 'Depression';

			%if &type=on %then  end; ;
			
    end;

    TOT_GRP = ELX_GRP_1  + ELX_GRP_2  +  ELX_GRP_3  +  ELX_GRP_4  +  ELX_GRP_5  +  ELX_GRP_6  +  ELX_GRP_7  +
              ELX_GRP_8  + ELX_GRP_9  +  ELX_GRP_10 +  ELX_GRP_11 +  ELX_GRP_12 +  ELX_GRP_13 +  ELX_GRP_14 +
              ELX_GRP_15 + ELX_GRP_16 +  ELX_GRP_17 +  ELX_GRP_18 +  ELX_GRP_19 +  ELX_GRP_20 +  ELX_GRP_21 +
              ELX_GRP_22 + ELX_GRP_23 +  ELX_GRP_24 +  ELX_GRP_25 +  ELX_GRP_26 +  ELX_GRP_27 +  ELX_GRP_28 +
              ELX_GRP_29 + ELX_GRP_30 +  ELX_GRP_31;
     LABEL TOT_GRP='Total Elixhauser Groups per record';

	run;
    
	options notes ;
	 %put ;
	 %put NOTE: _Elixhauser Finished &out created ;
     %put ;	

	%goto exit ;
	
    %out1:
		%put ERROR: Prior Step failed with an Error submit a null data step to correct ;
	%goto exit ;

	%out2:
		%put ERROR: Input Data Was Not Defined;
	%goto exit ;

    %out3:
        %put ERROR: Input Data &libname..&data does not exist ;
        %goto exit ;	

    %exit:
	
     %**** Reset the SAS options ;
     options &opts ; 

%mend _ElixhauserICD10;

*Create a temp file for calling macro;
data merge_all_0015_dgns_ICD10;
   set tempn.merge_all_0015_dgns_ICD10;
run;

*Call macro;
   %_ElixhauserICD10  (DATA    =merge_all_0015_dgns_ICD10,
                       OUT     =tempn.merge_all_0015_dgns_ICD10_2,
                       dx      =DGNS_CD01-DGNS_CD10,
                       dxtype  =,
                       type    =off, 
                       debug   =off ) ;					   
run;


*Combine cohort of ICD-9 with cohort of ICD-10;
data tempn.merge_all_0015_dgns_2 (drop=i);
set tempn.merge_all_0015_dgns_ICD9_2 tempn.merge_all_0015_dgns_ICD10_2;
run; *139,782,151 records;

PROC FREQ data=tempn.merge_all_0015_dgns_2;
   TITLE1  "Summary of Elixhauser Comorbidity Groups";
   TABLES  ELX_GRP: TOT_GRP;
RUN;
ods rtf close;



/***********************************************************
 Step 5 - Generate final analytical data set; 
***********************************************************/

data PAC.merge_all_2000_15_final;
set tempn.merge_all_0015_dgns_2;
run;
















