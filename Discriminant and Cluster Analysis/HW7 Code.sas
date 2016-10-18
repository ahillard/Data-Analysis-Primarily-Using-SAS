﻿DATA pain (TYPE = corr);
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW7\pain.dat" MISSOVER;
INPUT _type_ $ _name_ $ p1 - p9;
RUN;

/*Part a*/

PROC FACTOR DATA=pain METHOD=ML HEYWOOD N=2;
TITLE 'MLE Factor Analysis with 2 Factors';
RUN;

/*Part b*/

PROC FACTOR DATA=pain METHOD=ML HEYWOOD N=3 ROTATE=VARIMAX;
TITLE 'MLE Factor Analysis with 3 Factors and Varimax Rotation';
RUN;

/*Part c*/

PROC FACTOR DATA=pain PRIORS=SMC ROTATE=VARIMAX OUTSTAT=fact_all N=3;
TITLE 'Principal Factor Method with 3 Factors and Varimax Rotation';
RUN;

/*Part d*/

PROC FACTOR DATA=pain PRIORS=SMC ROTATE=PROMAX N=3;
TITLE 'Principal Factor Method with 3 Factors and Oblique Rotation';
RUN;

/*Problem 2*/

/*Import Data*/

PROC IMPORT OUT= WORK.spam_train 
            DATAFILE= "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW7\spamdetect_train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=NO;
     DATAROW=1; 
RUN;

PROC IMPORT OUT= WORK.spam_test 
            DATAFILE= "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW7\spamdetect_test.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=NO;
     DATAROW=1; 
RUN;

PROC PRINT DATA=spam_test;
RUN;

/*Part a*/

PROC DISCRIM DATA=spam_train POOL=TEST SLPOOL=.01;
CLASS VAR58;
VAR VAR1-VAR57;
RUN;

/*Part b*/

PROC DISCRIM DATA=spam_train METHOD=NORMAL POOL=YES CROSSVALIDATE OUTSTAT=spamstat;
CLASS VAR58;
PRIORS '0'=0.5 '1'=0.5;
VAR VAR1-VAR57;
RUN;

PROC DISCRIM DATA=spamstat TESTDATA=spam_test TESTOUT=tout TESTLIST;
CLASS VAR58;
VAR VAR1-VAR57;
TITLE 'Linear Discriminant Classification of test Data';
RUN;

/*Part c*/

PROC DISCRIM DATA=spam_train METHOD=NORMAL POOL=NO CROSSVALIDATE OUTSTAT=spamstat2;
CLASS VAR58;
PRIORS '0'=0.5 '1'=0.5;
VAR VAR1-VAR57;
RUN;

PROC DISCRIM DATA=spamstat2 TESTDATA=spam_test TESTOUT=tout TESTLIST;
CLASS VAR58;
VAR VAR1-VAR57;
TITLE ' Classification of Test Data Quadratic';
RUN;

/*Part d */

PROC STEPDISC DATA=spam_train METHOD=FORWARD SLENTRY=.01;
CLASS VAR58;
VAR VAR1-VAR57;
RUN;

/*Quadratic Discriminant with Subset*/

PROC DISCRIM DATA=spam_train METHOD=NORMAL POOL=NO CROSSVALIDATE OUTSTAT=spamstat3;
CLASS VAR58;
PRIORS '0'=0.5 '1'=0.5;
VAR VAR21 VAR23 VAR7 VAR57 VAR16 VAR52 VAR25 VAR5 VAR53 VAR8 VAR24 VAR6 VAR20 VAR18 VAR22 VAR42 VAR27 VAR46 
VAR45 VAR49 VAR19 VAR56 VAR17 VAR12 VAR37 VAR33 VAR26 VAR44 VAR48 VAR43 VAR4 VAR9 VAR3 VAR1 VAR11 VAR35; 
RUN;

PROC DISCRIM DATA=spamstat3 TESTDATA=spam_test TESTOUT=tout TESTLIST;
CLASS VAR58;
VAR VAR21 VAR23 VAR7 VAR57 VAR16 VAR52 VAR25 VAR5 VAR53 VAR8 VAR24 VAR6 VAR20 VAR18 VAR22 VAR42 VAR27 VAR46 
VAR45 VAR49 VAR19 VAR56 VAR17 VAR12 VAR37 VAR33 VAR26 VAR44 VAR48 VAR43 VAR4 VAR9 VAR3 VAR1 VAR11 VAR35; 
TITLE ' Classification of Test Data Quadratic with subset of Variables';
RUN;

/*Linear Discriminant with Subset*/

PROC DISCRIM DATA=spam_train METHOD=NORMAL POOL=YES CROSSVALIDATE OUTSTAT=spamstat4;
CLASS VAR58;
PRIORS '0'=0.5 '1'=0.5;
VAR VAR21 VAR23 VAR7 VAR57 VAR16 VAR52 VAR25 VAR5 VAR53 VAR8 VAR24 VAR6 VAR20 VAR18 VAR22 VAR42 VAR27 VAR46 
VAR45 VAR49 VAR19 VAR56 VAR17 VAR12 VAR37 VAR33 VAR26 VAR44 VAR48 VAR43 VAR4 VAR9 VAR3 VAR1 VAR11 VAR35; 
RUN;

PROC DISCRIM DATA=spamstat4 TESTDATA=spam_test TESTOUT=tout TESTLIST;
CLASS VAR58;
VAR VAR21 VAR23 VAR7 VAR57 VAR16 VAR52 VAR25 VAR5 VAR53 VAR8 VAR24 VAR6 VAR20 VAR18 VAR22 VAR42 VAR27 VAR46 
VAR45 VAR49 VAR19 VAR56 VAR17 VAR12 VAR37 VAR33 VAR26 VAR44 VAR48 VAR43 VAR4 VAR9 VAR3 VAR1 VAR11 VAR35; 
TITLE ' Classification of Test Data Linear with subset of Variables';
RUN;


/*Problem 3*/

PROC IMPORT OUT= WORK.USAIR 
            DATAFILE= "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW7\usair.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=NO;
     DATAROW=1; 
RUN;

DATA usair2;
SET usair;
id = _N_;
PROC PRINt;
RUN;

/*Part a*/

PROC CLUSTER DATA=usair2  METHOD=COMPLETE plots=dendrogram(height=rsq) PSEUDO;
VAR VAR2-VAR7;
ID id;
RUN;

/*Part b*/

PROC FASTCLUS DATA=usair2 MAXC=4 MAXITER=10 OUT=CLUS;
VAR VAR2-VAR7;
RUN;

PROC GLM DATA=CLUS;
CLASS CLUSTER;
MODEL VAR1=CLUSTER;
RUN;