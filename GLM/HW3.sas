/*Problem 1 */

DATA Attendance;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW3\nbreg.txt" DLM='09'x;
INPUT id school male math langarts daysatt daysabs;
RUN;

PROC PRINT;
RUN;

PROC GENMOD DATA=Attendance DESCENDING;
MODEL daysabs = male math langarts / DIST=negbin LINK=log TYPE1 TYPE3;
RUN;

PROC GENMOD DATA=Attendance DESCENDING;
MODEL daysabs = / DIST=negbin LINK=log TYPE1 TYPE3;
RUN;  

/* Problem 3 */

DATA p2;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW3\auto_mpg_data2_train.dat';
INPUT mpg cylinders displacement horsepower weight acceleration year origin;
mpg01 = 1;
RUN;

PROC MEANS DATA=p2 Median;
VAR mpg;
RUN;

DATA p2b; 
SET p2;
IF mpg > 22.45 THEN mpg01 = 1;
IF mpg < 22.45 THEN mpg01 =0;
RUN;

PROC PRINT;
RUN;

PROC GPLOT DATA=p2b;
PLOT (cylinders displacement horsepower weight acceleration year origin)*mpg01;
RUN;


PROC GENMOD DATA=p2b DESCENDING;
MODEL mpg01 = / DIST=BINOMIAL LINK=logit TYPE1 TYPE3;
RUN;

PROC GENMOD DATA=p2b DESCENDING;
MODEL mpg01 = displacement horsepower weight / DIST=BINOMIAL LINK=logit TYPE1 TYPE3;
RUN;

PROC GENMOD DATA=p2b DESCENDING;
MODEL mpg01 = displacement horsepower weight acceleration / DIST=BINOMIAL LINK=logit TYPE1 TYPE3;
RUN;

PROC GENMOD DATA=p2b DESCENDING;
MODEL mpg01 = displacement horsepower weight acceleration weight*acceleration / DIST=BINOMIAL LINK=logit TYPE1 TYPE3;
OUTPUT OUT=output1 STDRESDEV=stdeviance PRED=predicted XBETA=xb;
RUN;


PROC LOGISTIC DATA=p2b DESCENDING;
MODEL mpg01 = displacement horsepower weight acceleration weight*acceleration / CTABLE PPROB = (0.0 TO 1.0 BY 0.1);
RUN;

PROC GPLOT DATA=output1;
PLOT xb*stdeviance;
RUN;

/*Part c of Problem 3 */

DATA p2t;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW3\auto_mpg_data2_test.dat';
INPUT mpg cylinders displacement horsepower weight acceleration year origin;
mpg01 = 1;
RUN;

DATA p2tb; 
SET p2t;
IF mpg > 22.45 THEN mpg01 = 1;
IF mpg < 22.45 THEN mpg01 =0;
RUN;

PROC PRINT;
RUN;

PROC LOGISTIC DATA=p2b DESCENDING  OUTMODEL=m1 NOPRINT;
MODEL mpg01 = displacement horsepower weight acceleration weight*acceleration;
RUN;

PROC LOGISTIC INMODEL=m1 DESCENDING;
SCORE DATA=p2b OUT=Score;
RUN;

PROC FREQ DATA=Score; 
   TABLE F_mpg01*I_mpg01 / NOCOL NOCUM NOPERCENT; 
RUN;



PROC LOGISTIC INMODEL=m1;
SCORE DATA=p2tb OUT=Score3;
RUN;

PROC PRINT DATA=Score3;
RUN;

PROC FREQ data=Score3; 
   TABLE F_mpg01*I_mpg01 / nocol nocum nopercent; 
run;

PROC PRINT DATA=Score3;
RUN;



PROC LOGISTIC INMODEL=m1;
   SCORE DATA=p2b OUT=Score1;
RUN;

PROC FREQ data=Score1; 
   table F_mpg01*I_mpg01 / nocol nocum nopercent; 
RUN;

/* For Part c Write Up*/


DATA p2t;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW3\auto_mpg_data2_test.dat';
INPUT mpg cylinders displacement horsepower weight acceleration year origin;
mpg01 = 1;
RUN;

DATA p2tb; 
SET p2t;
IF mpg > 22.45 THEN mpg01 = 1;
IF mpg < 22.45 THEN mpg01 =0;
RUN;

PROC LOGISTIC DATA=p2b DESCENDING  OUTMODEL=model1 NOPRINT;
MODEL mpg01 = displacement horsepower weight acceleration weight*acceleration;
RUN;

PROC LOGISTIC INMODEL=model1;
SCORE DATA=p2tb OUT=Score3;
RUN;

PROC FREQ DATA=Score3; 
   TABLE F_mpg01*I_mpg01 / NOCOL NOCUM NOPERCENT; 
RUN;


/* Problem 4 */

DATA fish;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW3\benthicfish.dat';
INPUT count macrohabitat gear;
RUN;

DATA benthic;
SET fish;
IF macrohabitat = 1 THEN X1=-1;
ELSE X1=0;
IF macrohabitat = 2 THEN X2=-1;
ELSE X2=0;
IF macrohabitat = 3 THEN X3=-1;
ELSE X3=0;
RUN;

PROC GENMOD DATA=benthic DESCENDING;
MODEL count = X1 X2 X3 / DIST=POISSON LINK=log TYPE1 TYPE3;
RUN;


/* Problem 4 Part b */

DATA benthic2;
SET fish;
IF macrohabitat = 1 THEN X1=1;
ELSE X1=0;
IF macrohabitat = 2 THEN X2=1;
ELSE X2=0;
IF macrohabitat = 3 THEN X3=1;
ELSE X3=0;
IF macrohabitat = 4 THEN X4=1;
ELSE X4=0;
IF gear = 1 THEN G1 = 1;
ELSE G1=0;
IF gear = 2 THEN G2 = 1;
ELSE G2=0;
IF gear = 3 THEN G3 = 1;
ELSE G3=0;
IF gear = 4 THEN G4 = 1;
ELSE G4=0;
PROC PRINT;
RUN;

PROC GENMOD DATA=benthic2 DESCENDING;
MODEL count = X1 X2 X3 / DIST=zip LINK=LOG;
ZEROMODEL G1 G2 G3 G4 / LINK=LOGIT;
RUN;
