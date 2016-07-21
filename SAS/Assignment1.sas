/*assignment 1*/

libname a1 '/folders/myfolders/A1';

/*question 1*/
/*importing car_sales.csv using proc import*/
proc import datafile= '/folders/myfolders/A1/car_sales.csv'
out= a1.carsales dbms=csv replace;
getnames=yes; guessingrows= 100;
run;

/*question 2*/
/*removing missing values in the resale or price variable*/
data a1.carsales_cleaned;
set a1.carsales;
where _4_year_resale_value ^=. and price_in_thousands ^=.;
run;

/*question 3*/
/*5 datasets for 5 price ranges*/

data a1.PR1 a1.PR2 a1.PR3 a1.PR4 a1.PR5;
set a1.carsales;
if price_in_thousands < 15 then output a1.PR1;
if 15 <= price_in_thousands < 20 then output a1.PR2;
if 20 <= price_in_thousands < 30 then output a1.PR3;
if 30 <= price_in_thousands < 40 then output a1.PR4;
if price_in_thousands > 40 then output a1.PR5;

run;


/*question 4*/
/*data with 4 variables: manufacturer, model, sales and price*/
data a1._4vardata;
set a1.carsales (keep = manufacturer model sales_in_thousands price_in_thousands);
run;

/*question 5*/
/*data for passenger vehicles launched after 1-Oct-2014*/
data a1.pvafteroct14;
set a1.carsales;
where '1-Oct-2014'd < latest_launch and vehicle_type = "Passenger";
run;