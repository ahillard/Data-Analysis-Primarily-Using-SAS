DATA split;
INPUT plot past min milk @@;
DATALINES;
1 4 2 30 1 4 1 29 1 1 2 27 1 1 1 25
1 2 1 26 1 2 2 28 1 3 2 26 1 3 1 24
2 2 1 32 2 2 2 37 2 1 2 30 2 1 1 31
2 4 1 34 2 4 2 37 2 3 1 33 2 3 2 32
3 1 2 34 3 1 1 31 3 2 1 30 3 2 2 31
3 4 2 36 3 4 1 38 3 3 1 33 3 3 2 32
PROC PRINT;
RUN;

PROC MIXED DATA=split METHOD=type3;
CLASS past min plot;
MODEL milk = past|min / SOLUTION;
RANDOM plot past*plot / SOLUTION;
RUN;

/*Mixed Model with ANOVA Table*/

PROC GLM DATA=split;
CLASS past min plot;
MODEL milk = plot past past*plot min past*min;
RANDOM plot past*plot / TEST;
RUN;

/*Part b*/

PROC MIXED DATA=split METHOD=type3;
CLASS past min plot;
MODEL milk = past|min / SOLUTION DDFM=KENWARDROGER;
RANDOM plot past*plot / SOLUTION;
RUN;

/*Part c*/

PROC MIXED DATA=split METHOD=type3;
CLASS past min plot;
MODEL milk = past|min / SOLUTION;
RANDOM plot past*plot / SOLUTION;
LSMEANS past / ADJUST=TUKEY;
RUN;

/*Problem 5*/

DATA alzheim;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW4\alzheim.dat";
INPUT group score1-score5;
ARRAY sc {5} score1-score5;
idno=_n_;
DO visit=1 TO 5;
score=sc{visit};
OUTPUT;
END;
PROC PRINT;
RUN;


DATA a1;
SET alzheim;
IF group='1';
RUN;

DATA a2;
SET alzheim;
IF group='2';
RUN;


PROC SGPLOT DATA=a1;
TITLE 'Profile Plots for Subjects in Placebo Group';
SERIES X=visit Y=score / GROUP = idno;
RUN;

PROC SGPLOT DATA=a2;
TITLE 'Profile Plots for Subjects in Lecithin Group';
SERIES X=visit Y=score / GROUP = idno;
RUN;

/*Part d*/

PROC VARCOMP DATA=alzheim METHOD=ml;
CLASS idno group;
MODEL score = group idno / FIXED = 1 ;
RUN;

PROC MIXED DATA=alzheim METHOD=ml;
CLASS idno group;
MODEL score = visit group / SOLUTION OUTP=model1;
RANDOM INTERCEPT / SUBJECT=idno SOLUTION;
RUN;


DATA b1;
SET model1;
IF group='1';
RUN;

DATA b2;
SET model1;
IF group='2';
RUN;


PROC SGPLOT DATA=b1;
TITLE 'Predicted Profile Plots for Subjects in Placebo Group';
SERIES X=visit Y=Pred / GROUP = idno;
RUN;

PROC SGPLOT DATA=b2;
TITLE 'Predicted Profile Plots for Subjects in Lecithin Group';
SERIES X=visit Y=Pred / GROUP = idno;
RUN;

/*Part f*/

PROC MIXED DATA=alzheim METHOD=ml;
CLASS idno group;
MODEL score = visit group / SOLUTION OUTP=model3;
RANDOM INTERCEPT visit / TYPE=UN SUBJECT=idno SOLUTION;
RUN;

PROC MIXED DATA=alzheim METHOD=ml;
CLASS idno group;
MODEL score = visit group / SOLUTION;
RANDOM INTERCEPT visit / SUBJECT=idno SOLUTION;
RUN;

DATA c1;
SET model3;
IF group='1';
RUN;

DATA c2;
SET model3;
IF group='2';
RUN;


PROC SGPLOT DATA=c1;
TITLE 'Predicted Profile Plots for Subjects in Placebo Group';
SERIES X=visit Y=Pred / GROUP = idno;
RUN;

PROC SGPLOT DATA=c2;
TITLE 'Predicted Profile Plots for Subjects in Lecithin Group';
SERIES X=visit Y=Pred / GROUP = idno;
RUN;

/*Part g*/

PROC MIXED DATA=alzheim METHOD=ml;
CLASS idno group;
MODEL score = visit group / SOLUTION OUTP=model4;
RANDOM INTERCEPT visit / TYPE=UN SUBJECT=idno SOLUTION; 
REPEATED / TYPE=AR(1) SUBJECT=idno;
RUN;
