DATA g;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW5\growthdata.dat";
INPUT time plant1-plant6;
RUN;

/*
PROC TRANSPOSE DATA=g OUT=g1 PREFIX=m NAME=plantnumber; 
PROC PRINT DATA=g1;
RUN;

PROC PRINT DATA=g;
RUN;
*/

DATA g1;
SET g;
ARRAY sc {6} plant1-plant6;
DO i=1 TO 6;
idno = i;
measurement = sc{i};
OUTPUT;
END;
RUN;

DATA growth;
SET g1;
KEEP time idno measurement;
RUN;

PROC SORT DATA=growth;
BY idno time;
PROC PRINT;
RUN;


PROC GPLOT DATA=growth;
PLOT measurement*time;
BY idno;
RUN;

PROC PLOT DATA=g1;
PLOT measurement*time;
BY idno;
RUN;

PROC MEANS DATA=growth;
VAR measurement;
BY time;
RUN;

/* Starting Value Work 

PROC MEANS DATA=g1;
VAR m1 m2 m3 m4 m5 m6 m7 m8 m9 m10;
RUN;

DATA growthmeans;
INPUT time measurement; 
DATALINES;
1 19.8049344 
2 64.5095058 
3 117.7111735 
4 175.9353087 
5 233.0258950 
6 294.6672093 
7 347.5332900 
8 396.9471600 
9 434.4063783 
10 477.7608333 
;
PROC PLOT DATA=growthmeans;
PLOT measurement*time;
RUN;
PROC REG DATA=growthmeans;
MODEL measurement = ;
RUN;
 */

PROC NLIN DATA=growth METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	b1 = 200
		b2 = 1500
		b3 = 1029.27;
MODEL measurement = (b1)/(1 + exp(-(time-b2)/b3));
RUN;

/*NLMIXED STUFF */

PROC NLMIXED DATA=growth;
parms b1=199.7 b2=797.8 b3=300.7 resvar=500 varu=500;
num = b1 + u;
den = 1 + exp(-(time-b2)/b3);
model measurement ~ normal(num/den, resvar);
random u ~ normal(0, varu) subject=idno;
predict num/den out=result1;
RUN;

PROC PRINT DATA=result1;
RUN;

PROC NLMIXED DATA=growth;
parms b1=199.7 b2=797.8 b3=300.7 resvar=500;
num = b1;
den = 1 + exp(-(time-b2)/b3);
model measurement ~ normal(num/den, resvar);
RUN;

PROC NLMIXED DATA=growth;
parms b1=199.7 b2=797.8 b3=300.7 resvar=500 varu=500;
num = b1 + u;
den = 1 + exp(-(time-b2)/350);
model measurement ~ normal(num/den, resvar);
random u ~ normal(0, varu) subject=idno;
RUN;

/*Plots*/

GOPTIONS RESET=ALL;

Title1 "Predictions vs Actual Measurements";
symbol1 interpol=join
        value=dot
        color=_style_;
symbol2 interpol=join
        value=C
        font=marker
        color=_style_ ;
legend1 label=none
        position=(top center inside)
        mode=share;


PROC GPLOT DATA=result1;
PLOT measurement*time Pred*time / Overlay legend=legend1;
BY idno;
RUN;


/*Problem 3*/

DATA latlong;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW5\MOtornlatlon.dat";
INPUT lat long;
PROC PRINT;
RUN;


DATA tmp1;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW5\ssttornado532001.dat";
INPUT year1-year49;
PROC TRANSPOSE DATA=tmp1 OUT=tmp2 Name=year Prefix=loc;
RUN;

PROC PRINT DATA=tmp1;
RUN;

DATA tmp3;
SET tmp2;
ARRAY my[20] loc2-loc21;
year=_n_;
sst = loc1;
DO i = 1 to 20;
location = (i);
count = my[i];
OUTPUT;
END;
RUN;

DATA tornado;
SET tmp3 (KEEP=year sst location count);
IF location=1 THEN lat=38.9253;
IF location=2 THEN lat=38.4756;
IF location=3 THEN lat=38.0259;
IF location=4 THEN lat=37.5763;
IF location=5 THEN lat=38.9253;
IF location=6 THEN lat=38.4756;
IF location=7 THEN lat=38.0259;
IF location=8 THEN lat=37.5763;
IF location=9 THEN lat=38.9253;
IF location=10 THEN lat=38.4756;
IF location=11 THEN lat=38.0259;
IF location=12 THEN lat=37.5763;
IF location=13 THEN lat=38.9253;
IF location=14 THEN lat=38.4756;
IF location=15 THEN lat=38.0259;
IF location=16 THEN lat=37.5763;
IF location=17 THEN lat=38.9253;
IF location=18 THEN lat=38.4756;
IF location=19 THEN lat=38.0259;
IF location=20 THEN lat=37.5763;
IF location=1 THEN long=-93.4749;
IF location=2 THEN long=-93.5564;
IF location=3 THEN long=-93.6361;
IF location=4 THEN long=-93.7141;
IF location=5 THEN long=-92.8969;
IF location=6 THEN long=-92.9820;
IF location=7 THEN long=-93.0653;
IF location=8 THEN long=-93.1467;
IF location=9 THEN long=-92.3189;
IF location=10 THEN long=-92.4076;
IF location=11 THEN long=-92.4944;
IF location=12 THEN long=-92.5793;
IF location=13 THEN long=-91.7409;
IF location=14 THEN long=-91.8332;
IF location=15 THEN long=-91.9236;
IF location=16 THEN long=-92.0119;
IF location=17 THEN long=-91.1629;
IF location=18 THEN long=-91.2589;
IF location=19 THEN long=-91.3528;
IF location=20 THEN long=-91.4446;
PROC PRINT DATA=tornado;
RUN;

/*Both Fixed Effects and Both Random*/

PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst / DIST=poisson LINK=log SOLUTION;
RANDOM INTERCEPT sst / SUBJECT=location SOLUTION;
NLOPTIONS tech=newrap;
OUTPUT OUT=out1 pred(ilink)=predicted lcl(ilink)=lower ucl(ilink)=upper pred(noblup ilink)=margpred;
RUN;

PROC PRINT DATA=out1;
RUN;

PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst / DIST=poisson LINK=log SOLUTION;
RANDOM INTERCEPT / SUBJECT=location SOLUTION;
NLOPTIONS tech=newrap;
OUTPUT OUT=out1 pred(ilink)=predicted lcl(ilink)=lower ucl(ilink)=upper pred(noblup ilink)=margpred;
RUN;


PROC GENMOD DATA=tornado;
MODEL count = sst / DIST=poisson LINK=log;
RUN;

PROC GENMOD DATA=tornado;
MODEL count = / DIST=poisson LINK=log;
RUN;




/*Trying other stuff*/

PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst / DIST=poisson LINK=log SOLUTION;
RANDOM INTERCEPT sst / SUBJECT=location type=sp(exp) (long lat) SOLUTION;
NLOPTIONS tech=newrap;
OUTPUT OUT=out1 pred(ilink)=predicted lcl(ilink)=lower ucl(ilink)=upper pred(noblup ilink)=margpred;
RUN;

PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst sst*location / DIST=poisson LINK=log SOLUTION;
RANDOM INTERCEPT / SUBJECT=location type=sp(exp) (long lat) SOLUTION;
NLOPTIONS tech=newrap;
OUTPUT OUT=out1 pred(ilink)=predicted lcl(ilink)=lower ucl(ilink)=upper pred(noblup ilink)=margpred;
RUN;


PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst sst*location / DIST=poisson LINK=log SOLUTION;
NLOPTIONS tech=newrap;
RUN;

PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst*location / DIST=poisson LINK=log SOLUTION;
NLOPTIONS tech=newrap;
RUN;

PROC GLIMMIX DATA=tornado;
CLASS location year;
MODEL count = sst sst*location/ DIST=poisson LINK=log SOLUTION;
RANDOM INTERCEPT sst sst*location/ SUBJECT=location type=sp(exp) (long lat) SOLUTION;
NLOPTIONS tech=newrap;
OUTPUT OUT=out1 pred(ilink)=predicted lcl(ilink)=lower ucl(ilink)=upper pred(noblup ilink)=margpred;
RUN;














