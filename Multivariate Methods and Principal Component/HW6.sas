/*Homework 6 */

DATA p6;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW6\PothoffRoy1964.dat";
INPUT id gender $ eight ten twelve fourteen;
RUN;

PROC PRINT DATA=p6;
RUN;

/*Part a*/

PROC GLM DATA=p6;
CLASS gender;
MODEL eight ten twelve fourteen = gender/ NOUNI;
REPEATED time 4 POLYNOMIAL / PRINTE SUMMARY MEAN;
Title 'Part a Mauchly Test';
RUN;

/*Part b*/

PROC GLM DATA=p6;
CLASS gender;
MODEL eight ten twelve fourteen = gender / NOUNI;
CONTRAST '(1) Parallel Profile' gender +1 -1;
MANOVA M = (+1 -1 0 0,
			0 +1 -1 0, 
			0 0 +1 -1);
TITLE 'Parallel Profile';
RUN;


PROC GLM DATA=p6;
CLASS gender;
MODEL eight ten twelve fourteen = gender / NOUNI;
CONTRAST '(2) Coincidental Profile' gender +1 -1;
MANOVA M = (+1 +1 +1 +1);
TITLE 'Coincidental Profile';
RUN;

PROC GLM DATA=p6;
CLASS gender;
MODEL eight ten twelve fourteen = gender / NOUNI;
CONTRAST '(3) Horizontal Profile' INTERCEPT 1;
MANOVA M = (+1 -1 0 0,
			0 +1 -1 0,
			0 0 +1 -1);
TITLE 'Horizontal Profile';
RUN;

/*Part c*/

PROC GLM DATA=p6;
CLASS gender;
MODEL eight ten twelve fourteen = gender;
REPEATED time 4 POLYNOMIAL / PRINTE SUMMARY MEAN;
Title 'Part c Univariate tests v2';
RUN;

/*Part e*/

DATA p6_new;
INFILE "C:\Users\ajhkt6\Desktop\Spring 2016\Data Analysis 2\HW6\PothoffRoy1964.dat";
INPUT id gender $ y1 y2 y3 y4;
RUN;

DATA repeated_p6;
SET p6_new;
ARRAY t{4} y1-y4;
case +1;
	DO time=1 TO 4;
	y=t{time};
	OUTPUT;
END;
DROP y1-y4;
PROC PRINT;
RUN;
 
PROC MIXED DATA=repeated_p6 METHOD=REML COVTEST;
CLASS case gender time;
MODEL y=gender | time;
REPEATED / TYPE=CS SUBJECT=case R;
TITLE 'Compound Symmetry';
RUN;

/*Problem 3*/

DATA p3;
INPUT schedule id c1 c2 c3 c4;
DATALINES;
1 1 29 20 21 18
1 2 24 15 10 8
1 3 31 19 10 31
1 4 41 11 15 42
1 5 30 20 27 53
2 6 25 17 19 17
2 7 20 12 8 8
2 8 35 16 9 28
2 9 35 8 14 40
2 10 26 18 18 51
3 11 10 18 16 14
3 12 9 10 18 11
3 13 7 18 19 12
3 14 8 19 20 5
3 15 11 20 17 6
;
PROC PRINT;
RUN;

PROC SUMMARY NWAY DATA=p3;
CLASS schedule;
VAR c1 c2 c3 c4;
OUTPUT OUT=new MEAN=m1 m2 m3 m4;
RUN;


DATA plot;
SET new;
ARRAY m{4} m1 m2 m3 m4;
DO time=1 TO 4;
	response=m(time);
	OUTPUT;
END;
DROP m1 m2 m3 m4;
RUN;

AXIS1 LABEL = (ANGLE=90 H=1.2 'Response');
AXIS2 OFFSET = (15) LABEL = (H=1.2 'Time');
SYMBOL VALUE=DOT I=JOIN;
TITLE ' Profile Plot';

PROC GPLOT DATA=plot;
PLOT response*time=schedule / VAXIS=AXIS1 HAXIS=AXIS2 HMINOR=0 VMINOR=1;
RUN;

/*Part b*/

PROC GLM DATA=p3;
CLASS schedule;
MODEL c1 c2 c3 c4 = schedule / NOUNI;
MANOVA H=schedule / PRINTE PRINTH;
TITLE 'Overall Drug Effect';
RUN;

/*Part c Schedule 1 and 2 behave the same*/

PROC GLM DATA=p3;
CLASS schedule;
MODEL c1 c2 c3 c4 = schedule / NOUNI;
CONTRAST '(1) Parallel Profiles for Schedule 1 and 2' schedule +1 -1 0;
MANOVA M = (+1 -1 0 0,
			0 +1 -1 0, 
			0 0 +1 -1);
TITLE 'Parallel Profile';
RUN;


PROC GLM DATA=p3;
CLASS schedule;
MODEL c1 c2 c3 c4 = schedule / NOUNI;
CONTRAST '(2) Coincidental Profiles for Schedule 1 and 2' schedule +1 -1 0;
MANOVA M = (+1 +1 +1 +1);
TITLE 'Coincidental Profile';
RUN;

/*Part c Schedule 3 behaves differently - Show that Schedule 3 is different than 1 or 2*/

PROC GLM DATA=p3;
CLASS schedule;
MODEL c1 c2 c3 c4 = schedule / NOUNI;
CONTRAST '(1) Parallel Profiles for Schedule 1 and Schedule 3' schedule +1 0 -1;
MANOVA M = (+1 -1 0 0,
			0 +1 -1 0, 
			0 0 +1 -1);
TITLE 'Parallel Profile';
RUN;

PROC GLM DATA=p3;
CLASS schedule;
MODEL c1 c2 c3 c4 = schedule / NOUNI;
CONTRAST '(1) Parallel Profiles for Schedule 1 and Schedule 3' schedule 0 +1 -1;
MANOVA M = (+1 -1 0 0,
			0 +1 -1 0, 
			0 0 +1 -1);
TITLE 'Parallel Profile';
RUN;


/*Problem 4*/


DATA p4;
INPUT x1 x2 x3;
DATALINES;
7 4 3
4 1 8
6 3 5
8 6 1
8 5 7
7 2 9
5 3 3
9 5 8
7 4 5
8 2 2
;
RUN;

PROC PRINCOMP DATA=p4 COVARIANCE;
VAR x1 x2 x3;
TITLE 'Based on covariance matrix';
RUN;

/*Part i */


PROC PRINCOMP DATA=p4 OUT=new;
VAR x1 x2 x3;
TITLE 'Based on correlation matrix';
RUN;


/*Problem 5*/

DATA p5;
INPUT onehundred_meter long_jump shot_put high_jump fourhundred_meter hurdles discus pole_vault javelin
fifteenhundred_meter total_score;
DATALINES;
11.25	7.43	15.48	2.27	48.90	15.13	49.28	4.7	61.32	268.95	8488
10.87	7.45	14.97	1.97	47.71	14.46	44.36	5.1	61.76	273.02	8399
11.18	7.44	14.20	1.97	48.29	14.81	43.66	5.2	64.16	263.20	8328
10.62	7.38	15.02	2.03	49.06	14.72	44.80	4.9	64.04	285.11	8306
11.02	7.43	12.92	1.97	47.44	14.40	41.20	5.2	57.46	256.64	8286
10.83	7.72	13.58	2.12	48.34	14.18	43.06	4.9	52.18	274.07	8272
11.18	7.05	14.12	2.06	49.34	14.39	41.68	5.7	61.60	291.20	8216
11.05	6.95	15.34	2.00	48.21	14.36	41.32	4.8	63.00	265.86	8189
11.15	7.12	14.52	2.03	49.15	14.66	42.36	4.9	66.46	269.62	8180
11.23	7.28	15.25	1.97	48.60	14.76	48.02	5.2	59.48	292.24	8167
10.94	7.45	15.34	1.97	49.94	14.25	41.86	4.8	66.64	295.89	8143
11.18	7.34	14.48	1.94	49.02	15.11	42.76	4.7	65.84	256.74	8114
11.02	7.29	12.92	2.06	48.23	14.94	39.54	5.0	56.80	257.85	8093
10.99	7.37	13.61	1.97	47.83	14.70	43.88	4.3	66.54	268.97	8083
11.03	7.45	14.20	1.97	48.94	15.44	41.66	4.7	64.00	267.48	8036
11.09	7.08	14.51	2.03	49.89	14.78	43.20	4.9	57.18	268.54	8021
11.46	6.75	16.07	2.00	51.28	16.06	50.66	4.8	72.60	302.42	7869
11.57	7.00	16.60	1.94	49.84	15.00	46.66	4.9	60.20	286.04	7860
11.07	7.04	13.41	1.94	47.97	14.96	40.38	4.5	51.50	262.41	7859
10.89	7.07	15.84	1.79	49.68	15.38	45.32	4.9	60.48	277.84	7781
11.52	7.36	13.93	1.94	49.99	15.64	38.82	4.6	67.04	266.42	7753
11.49	7.02	13.80	2.03	50.60	15.22	39.08	4.7	60.92	262.93	7745
11.38	7.08	14.31	2.00	50.24	14.97	46.34	4.4	55.68	272.68	7743
11.30	6.97	13.23	2.15	49.98	15.38	38.72	4.6	54.34	277.84	7623
11.00	7.23	13.15	2.03	49.73	14.96	38.06	4.5	52.82	285.57	7579
11.33	6.83	11.63	2.06	48.37	15.39	37.52	4.6	55.42	270.07	7517
11.10	6.98	12.69	1.82	48.63	15.13	38.04	4.7	49.52	261.90	7505
11.51	7.01	14.17	1.94	51.16	15.18	45.84	4.6	56.28	303.17	7422
11.26	6.90	12.41	1.88	48.24	15.61	38.02	4.4	52.68	272.06	7310
11.50	7.09	12.94	1.82	49.27	15.56	42.32	4.5	53.50	293.85	7237
11.43	6.22	13.98	1.91	51.25	15.88	46.18	4.6	57.84	294.99	7231
11.47	6.43	12.33	1.94	50.30	15.00	38.72	4.0	57.26	293.72	7016
11.57	7.19	10.27	1.91	50.71	16.20	34.36	4.1	54.94	269.98	6907
12.12	5.83	9.71	1.70	52.32	17.05	27.10	2.6	39.10	281.24	5339
RUN;

PROC PRINT DATA=p5;
RUN;

DATA modified_p5;
SET p5;
DROP onehundred_meter fourhundred_meter fifteenhundred_meter hurdles;
onehundred = onehundred_meter * (-1);
fourhundred = fourhundred_meter * (-1);
fifteenhundred = fifteenhundred_meter * (-1);
hurd = hurdles * (-1);
PROC PRINT DATA=modified_p5;
RUN;

PROC FACTOR DATA=modified_p5 SIMPLE CORR SCREE PLOT;
VAR onehundred long_jump shot_put high_jump fourhundred hurd discus pole_vault javelin fifteenhundred;
TITLE 'Principal Component Method';
RUN;

DATA pcplot;
SET modified_p5;
KEEP PC1 PC2 total_score;
PC1 = 0.80381*onehundred+0.80955*long_jump+0.72617*shot_put+0.59950*high_jump+
0.65977*fourhundred+0.83688*hurd+0.68739*discus+0.87176*pole_vault+0.65732*javelin+
0.18733*fifteenhundred;
PC2 = 0.29443*onehundred+0.28540*long_jump-0.56852*shot_put+0.01069*high_jump+
0.61610*fourhundred+0.18928*hurd-0.60051*discus-0.08931*pole_vault-0.43032*javelin+
0.78686*fifteenhundred;
PROC PRINT DATA=pcplot;
RUN;

PROC SGPLOT DATA=pcplot;
SCATTER x=PC1 y=PC2 / datalabel=total_score;
TITLE 'Plot of PC1 vs. PC2 with Total Score Overlay';
RUN;

PROC CORR DATA=pcplot;
VAR PC1 PC2 total_score;
RUN;
