libname a3 '/folders/myfolders/a3';

proc import datafile= '/folders/myfolders/A1/car_sales.csv'
out= a3.carsales dbms=csv replace;
getnames=yes; guessingrows= 100;
run;

/*question1*/
/*country of origin*/

/*what manufacturers are there*/
proc freq data=a3.carsales;
table manufacturer/ nocum nopercent;
run;

data carsCOO;
set a3.carsales;
length org_country $20.;
select(manufacturer);
	when("Acura") org_country ="Japan";
	when("Audi") org_country ="Germany";
	when("BMW") org_country ="Germany";
	when("Buick") org_country ="US";
	when("Cadillac") org_country ="US";
	when("Chevrolet") org_country ="US";
	when("Chrysler") org_country ="US";
	when("Dodge") org_country ="US";
	when("Ford") org_country ="US";
	when("Honda") org_country ="Japan";
	when("Hyundai") org_country ="South Korea";
	when("Infiniti") org_country ="Japan";
	when("Jaguar") org_country ="UK";
	when("Jeep") org_country ="US";
	when("Lexus") org_country ="Japan";
	when("Lincoln") org_country ="US";
	when("Mercedes-Benz") org_country ="Germany";
	when("Mercury") org_country ="US";
	when("Mitsubishi") org_country ="Japan";
	when("Nissan") org_country ="Japan";
	when("Oldsmobile") org_country ="US";
	when("Plymouth") org_country ="US";
	when("Pontiac") org_country ="US";
	when("Porsche") org_country ="Germany";
	when("Saab") org_country ="Sweden";
	when("Saturn") org_country ="US";
	when("Subaru") org_country ="Canada";
	when("Toyota") org_country ="Japan";
	when("Volkswagen") org_country ="Germany";
	when("Volvo") org_country ="Sweden";
end;
run;

/*question 2*/
/*using trim or concatenate function*/
data a3.carsales_ID;
set a3.carsales;
Id = model||manufacturer;
run;

data a3.carsales_ID;
set a3.carsales;
Id = catx('-', manufacturer, model);
run;



/*question 3*/
/*creating two data sets*/
data varset1 (keep = Id manufacturer model latest_launch sales_in_thousands price_in_thousands _4_year_resale_value) varset2 (keep = Id vehicle_type Engine_size horsepower width wheelbase Length Curb_weight Fuel_capacity Fuel_efficiency);
set a3.carsales_ID;
run;
	
/*question 4*/
/*entering the data*/
data hyundai;
input manufacturer $ model $ sales_in_thousands _4_year_resale_value latest_launch date11.;
format latest_launch date9.;
cards;
Hyundai Tuscon 16.919 16.36 02 Feb 2012
Hyundai i45 39.384 19.875 3 Jun 2011
Hyundai Verna 14.114 18.225 4 Jan 2012
Hyundai Terracan 8.588 29.725 10 Mar 2011
;
run;

/*adding unique Id*/
data hyundai;
set hyundai;
Id = catx('-', manufacturer, model);
run;

/*question 5*/
data total_sales;
set varset1 hyundai;
run;

/*question 6*/
proc sort data = total_sales;
by Id;
run;

proc sort data=varset2;
by Id;
run;

data combinedq6;
merge total_sales varset2;
by Id;
run;

/*question 7*/
proc sort data = total_sales;
by Id;
run;

proc sort data=varset2;
by Id;
run;

data combinedq7;
merge total_sales(in=a) varset2(in=b);
by Id;
if a=1 and b=1;
run;