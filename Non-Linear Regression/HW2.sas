/*Problem 1*/

DATA process2;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW2\process2.dat';
INPUT Y X1 X2;
LABEL 	Y=Yield
		X1=Temperature
		X2=Pressure;
RUN;

PROC PRINT;
RUN;

/*Part A*/

PROC NLIN DATA=process2 METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	theta0 = 1 TO 21 BY 5
		theta1 = .2 TO .8 BY .1
		theta2 = .1 to .7 BY .1;
MODEL Y = theta0*(X1**theta1)*(X2**theta2);
OUTPUT OUT=result P=yhat L95M=lowint U95M=upint;
RUN;

/*Part B*/

DATA logprocess2;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW2\process2.dat';
INPUT Y X1 X2;
logY = log(Y);
logX1 = log(X1);
logX2 = log(X2);
RUN;

PROC PRINT;
RUN;

PROC REG DATA=logprocess2; 
MODEL logY = logX1 logX2;
RUN;

/*Part C*/

PROC NLIN DATA=process2 METHOD=GRADIENT SMETHOD=HALVE HOUGAARD;
PARMS 	theta0 = 9.591046
		theta1 = 0.51485
		theta2 = 0.29845;
MODEL Y = theta0*(X1**theta1)*(X2**theta2);
OUTPUT OUT=result P=yhat L95M=lowint U95M=upint;
RUN;

PROC NLIN DATA=process2 METHOD=NEWTON SMETHOD=HALVE HOUGAARD;
PARMS 	theta0 = 9.591046
		theta1 = 0.51485
		theta2 = 0.29845;
MODEL Y = theta0*(X1**theta1)*(X2**theta2);
OUTPUT OUT=result P=yhat L95M=lowint U95M=upint;
RUN;


PROC NLIN DATA=process2 METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	theta0 = 9.591046
		theta1 = 0.51485
		theta2 = 0.29845;
MODEL Y = theta0*(X1**theta1)*(X2**theta2);
OUTPUT OUT=result P=yhat L95M=lowint U95M=upint;
RUN;

/*Part E */

PROC NLIN DATA=process2 METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	theta0 = 9.591046
		theta1 = 0.51485
		theta2 = 0.29845;
MODEL Y = theta0*(X1**theta1)*(X2**theta2);
OUTPUT OUT=result P=PredictedValues R=residuals STUDENT=rstudent;
RUN;

PROC GPLOT DATA=result;
PLOT rstudent*(PredictedValues X1 X2);
RUN;

PROC CAPABILITY DATA=result noprint;
   PROBPLOT rstudent;
RUN;

/*Part i */

PROC NLIN DATA=process2 METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	theta0 = 9.591046
		theta1 = 0.40;
MODEL Y = theta0*(X1**theta1)*(X2**theta1);
RUN;

/*Part ii */

PROC NLIN DATA=process2 METHOD=GAUSS SMETHOD=HALVE HOUGAARD ALPHA=.025;
PARMS 	theta0 = 9.591046
		theta1 = 0.51485
		theta2 = 0.29845;
MODEL Y = theta0*(X1**theta1)*(X2**theta2);
OUTPUT OUT=result P=PredictedValues R=residuals STUDENT=rstudent;
RUN;

/*Problem 2*/

DATA swine;
INPUT x y;
xsquared = x**2;
DATALINES;
0.38	420
0.38	430
0.38	450
0.38	530
0.42	525
0.42	545
0.42	645
0.42	685
0.46	560
0.46	660
0.46	710
0.46	820
0.50	560
0.50	720
0.50	750
0.50	760
0.54	650
0.54	690
0.54	760
0.54	810
0.58	650
0.58	660
0.58	720
0.58	865
;
RUN;

PROC PRINT;
RUN;

PROC GPLOT DATA=swine;
PLOT y*x;
RUN;

/*Quadratic Model*/

PROC REG DATA=swine;
MODEL y=x xsquared;
RUN;

PROC NLIN DATA=swine METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	b0 = -2363.76228
		b1 = 11530
		b2 = -10728
		alpha = .48;
MODEL y = (b0 + b1*x + b2*x**2) * (x <= alpha) + (b0 + b1*alpha + b2*alpha**2) * (x > alpha);
RUN;

/*LINEAR MODEL*/

PROC REG DATA=swine;
MODEL y=x;
RUN;

PROC NLIN DATA=swine METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	b0 = 57.95833
		b1 = 1231.25
		alpha = .48;
MODEL y = (b0 + b1*x) * (x <= alpha) + (b0 + b1*alpha) * (x > alpha);
OUTPUT OUT=result1 P=PredictedValues R=residuals STUDENT=rstudent;
RUN;

PROC GPLOT DATA=result1;
PLOT rstudent*(PredictedValues);
RUN;

/*Problem 3*/

DATA dose;
INPUT x ref test y;
DATALINES;
1	0	1	0.072
2	0	1	0.092
3	0	1	0.138
4	0	1	0.199
5	0	1	0.267
6	0	1	0.345
7	0	1	0.436
8	0	1	0.518
1	0	1	0.046
2	0	1	0.086
3	0	1	0.122
4	0	1	0.184
5	0	1	0.257
6	0	1	0.344
7	0	1	0.428
8	0	1	0.516
1	1	0	0.140
2	1	0	0.113
3	1	0	0.141
4	1	0	0.203
5	1	0	0.284
6	1	0	0.364
7	1	0	0.451
8	1	0	0.529
1	1	0	0.071
2	1	0	0.090
3	1	0	0.132
4	1	0	0.194
5	1	0	0.259
6	1	0	0.361
7	1	0	0.450
8	1	0	0.540
;
RUN;

DATA dosetest;
INPUT x ref test y;
DATALINES;
1	0	1	0.072
2	0	1	0.092
3	0	1	0.138
4	0	1	0.199
5	0	1	0.267
6	0	1	0.345
7	0	1	0.436
8	0	1	0.518
1	0	1	0.046
2	0	1	0.086
3	0	1	0.122
4	0	1	0.184
5	0	1	0.257
6	0	1	0.344
7	0	1	0.428
8	0	1	0.516
;
RUN;

DATA doseref;
INPUT x ref test y;
DATALINES;
1	1	0	0.140
2	1	0	0.113
3	1	0	0.141
4	1	0	0.203
5	1	0	0.284
6	1	0	0.364
7	1	0	0.451
8	1	0	0.529
1	1	0	0.071
2	1	0	0.090
3	1	0	0.132
4	1	0	0.194
5	1	0	0.259
6	1	0	0.361
7	1	0	0.450
8	1	0	0.540
;
RUN;

PROC GPLOT DATA=dosetest;
PLOT y*x;
RUN;

PROC GPLOT DATA=doseref;
PLOT y*x;
RUN;

/*Full Model*/

PROC NLIN DATA=dose METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a1 = 0.5
		b1 = 0.5 TO 1.5 BY .5
		x01 = 4.5
		a2 = 0.5
		b2 = 0.5 TO 1.5 BY .5
		x02 = 4.5;
MODEL y = ( a1 / (1+exp(-(x-x01)/b1)) ) * (test=1) + ( a2 / (1+exp(-(x-x02)/b2)) ) * (ref=1);
RUN;

/*Reduced Model*/

PROC NLIN DATA=dose METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a = 0.5
		b = 0.5 TO 1.5 BY .5
		x1 = 4.5;
MODEL y = ( a / (1+exp(-(x-x1)/b)) );
RUN;

/*How are the models different */

PROC NLIN DATA=dose METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a1 = 0.5
		b1 = 0.5 TO 1.5 BY .5
		x01 = 4.5
		del_a1 = 0
		del_b1 = 0
		delx01 = 0;
		a2 = a1 + del_a1;
		b2 = b1 + del_b1;
		x02 = x01 + delx01;
MODEL y = ( a1 / (1+exp(-(x-x01)/b1)) ) * (test=1) + ( a2 / (1+exp(-(x-x02)/b2)) ) * (ref=1);
RUN;

/*Reduced Model to test a1 = a2*/

PROC NLIN DATA=dose METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a = 0.5
		b1 = 0.5 TO 1.5 BY .5
		x01 = 4.5
		b2 = 0.5 TO 1.5 BY .5
		x02 = 4.5;
MODEL y = ( a / (1+exp(-(x-x01)/b1)) ) * (test=1) + ( a / (1+exp(-(x-x02)/b2)) ) * (ref=1);
RUN;

/*Reduced Model to test b1 = b2*/

PROC NLIN DATA=dose METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a1 = 0.5
		b = 0.5 TO 1.5 BY .5
		x01 = 4.5
		a2 = 0.5
		x02 = 4.5;
MODEL y = ( a1 / (1+exp(-(x-x01)/b)) ) * (test=1) + ( a2 / (1+exp(-(x-x02)/b)) ) * (ref=1);
RUN;

/*Reduced Model to test x01 = x02*/

PROC NLIN DATA=dose METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a1 = 0.5
		b1 = 0.5 TO 1.5 BY .5
		x0 = 4.5
		a2 = 0.5
		b2 = 0.5 TO 1.5 BY .5;
		
MODEL y = ( a1 / (1+exp(-(x-x0)/b1)) ) * (test=1) + ( a2 / (1+exp(-(x-x0)/b2)) ) * (ref=1);
RUN;

/*Problem 4 */

DATA finch;
INFILE 'C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW2\finch6695.dat';
INPUT x y;
logy = log(y);
LABEL 	x=Year
		y=count
		;
RUN;

PROC PRINT;
RUN;

PROC GPLOT DATA=finch;
PLOT y*x;
RUN;

PROC GPLOT DATA=finch;
PLOT logy*x;
RUN;

PROC NLIN DATA=finch METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a = 12000
		b = 7
		c = .05
		;
MODEL logy = log(a)-b*exp(-c*(x-1966));
OUTPUT out=results4 p=yhat R=residuals STUDENT=rstudent;
RUN;


PROC NLIN DATA=finch METHOD=GAUSS SMETHOD=HALVE HOUGAARD;
PARMS 	a = 12000
		b = 7
		c = .05
		;
MODEL y = a*exp(-b*exp(-c*(x-1966)));
OUTPUT out=results3 p=yhat R=residuals STUDENT=rstudent;
RUN;

PROC GPLOT DATA=results3;
PLOT (y yhat) *x;
RUN;

PROC GPLOT DATA=results3;
PLOT rstudent * (x yhat);
RUN;

PROC CAPABILITY DATA=results3 noprint;
   PROBPLOT rstudent;
RUN;

PROC UNIVARIATE DATA=results3 NORMAL;
VAR rstudent;
RUN;

PROC UNIVARIATE DATA=results4 NORMAL;
VAR rstudent;
RUN;

PROC GPLOT DATA=results4;
PLOT rstudent * (x yhat);
RUN;
