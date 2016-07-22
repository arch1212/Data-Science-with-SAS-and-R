/*Assignment 5*/
/*Part 1*/

libname a5 '/folders/myfolders/Code/SAS';

/*importing data from excel*/
proc import datafile= '/folders/myfolders/A2/Grocery_Coupons'
out=a5.grocou dbms = xls replace;
sheet='Data'; getnames=yes;
run;

/*question1*/
data groctemp;
set a5.grocou;
dat = mdy(3,31,2014);
format dat date9.;

Cur_month_diff = intck('month', couponexpiry, today());
Cur_week_diff = intck('week', couponexpiry,today());
Cur_day_diff = intck('day', couponexpiry, today());

dat_month_diff = intck('month', couponexpiry, dat);
dat_week_diff = intck('month', couponexpiry, dat);
dat_day_diff = intck('month', couponexpiry, dat);

run;

/*question 2*/
data couponissuance;
set a5.grocou;
coup_issuance = intnx('month', couponexpiry,-3, 's');
format coup_issuance date9.;
run;

/*question 3*/
data date_diff;
set a5.grocou;
dat = mdy(9,30,2014);
format dat date9.;
date_diff = datdif(couponexpiry, dat ,'30/360');
run;

/*question 4*/
/*preparing the data*/
data amount;
set a5.grocou;
keep amtspent;
run;

data temp;
set amount;
/*charging the whole number amount*/
/*amount charged will calculated using int*/
amtspent_int = int(amtspent);
/*charging the exact amount*/
/*amount charged will calculated using round*/
amtspent_rnd = round(amtspent);

profit_int =  amtspent_int - amtspent;
profit_rnd = amtspent_rnd - amtspent;

run;

/*generating report*/
proc tabulate data = temp;
var profit_int profit_rnd;
table (profit_int = 'Profit from changing the amount to whole number' profit_rnd = 'Profit from rounding off the amount spent')* sum;
run;


/*part 2*/
/*Clean data using the text functions*/
/*import the data*/
proc import datafile= '/folders/myfolders/department.csv'
out=a5.dept dbms = csv replace;
getnames=yes; guessingrows= 100;
run;

/*question1*/
/*separating out the last name*/
data temp;
set a5.dept;
last_name = scan(Name, 1, ',');
run;

/*question 2*/
/*position of the first name*/
data pos_first_name;
set a5.dept;
first_name_position = find(Name, ", ") + 2;
run;

/*question 3*/
/*using the location, get the first name*/
data temp;
set pos_first_name;
first_name = substr(Name,first_name_position, 12);
run;



