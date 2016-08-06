libname cs2 '/folders/myfolders/SAS/CaseStudy/CS2/';

/*importing all the files*/

/*importing the csv Transaction files*/
proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/POS_Q1.csv'
out= cs2.pos1 dbms=csv replace;
getnames=yes; guessingrows= 100;

proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/POS_Q2.csv'
out= cs2.pos2 dbms=csv replace;
getnames=yes; guessingrows= 100;

proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/POS_Q3.csv'
out= cs2.pos3 dbms=csv replace;
getnames=yes; guessingrows= 100;

proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/POS_Q4.csv'
out= cs2.pos4 dbms=csv replace;
getnames=yes; guessingrows= 100;

/*importing Store locations file*/
proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/Store_Locations.csv'
out= cs2.sl dbms=csv replace;
getnames=yes; guessingrows= 100;

/*importing London Postal codes file*/
proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/London_postal_codes.csv'
out= cs2.lpc dbms=csv replace;
getnames=yes; guessingrows= 100;

/*Importing the configuration file*/
proc import datafile= '/folders/myfolders/SAS/CaseStudy/CS2/Laptops.csv'
out= cs2.config dbms=csv replace;
getnames=yes; guessingrows= 100;

/*Pricing*/

/*question 1*/

/*appending all Transaction datasets into one*/
proc append base=cs2.pos1 data=cs2.pos2;
run;

proc append base=cs2.pos1 data=cs2.pos3;
run;

proc append base=cs2.pos1 data=cs2.pos4;
run;

/*approach one*/

/*Creating Dataset for calculation of mean price change each month for each configuration*/
proc sql;
create table pvstime as
select Configuration, month, mean(Retail_price) as mean_price format dollar6.
from cs2.pos1
group by Configuration,month;
quit;

DATA change_q1_2;
SET pvstime;
LAG_PRICE = LAG(mean_price);
If month = 1 then LAG_PRICE = .;
DIF_PRICE = mean_price - LAG_PRICE;
RUN;

/*mean (price difference over months) for each configuration*/
proc sql;
create table final_1 as
select Configuration,mean(DIF_PRICE) as mean_pd format dollar6.
from change_q1_2
group by Configuration;
quit;

proc tabulate data = final_1;
var mean_pd;
table (mean_pd)*(mean);
run;


/*approach 2: 5*/
/*mean price and mean price difference for each month  */
proc sql;
create table final_2 as
select month, mean(mean_price) as mean_p_pc format dollar6.,mean(DIF_PRICE) as mean_pd format dollar6.
from change_q1_2
group by month;
quit;

/*mean price difference for each month*/
proc tabulate data = final_2;
var mean_pd;
table (mean_pd)*(mean sum);
run;

/*question 2*/

/*Creating Dataset with Store details, configurations sold and price*/
proc sql; 
create table q2 as 
select Store_Postcode, month, mean(Retail_price) as mean_price_month
from cs2.pos1
group by Store_Postcode, month;
quit;

/*percent change in price for each month*/
DATA percent_change_q2;
SET q2;
LAG_PRICE = LAG(mean_price_month);
Price_diff = mean_price_month- LAG_PRICE;
percent_change = (Price_diff/LAG_PRICE)*100;
RUN;

/*sorting the stores as per the discount categories*/
proc sql;
create table temp as 
select percent_change, Store_Postcode,month,
case 
WHEN percent_change =. then "NA"
WHEN -10<percent_change <0 then "Between 0 and 10"
WHEN -20< percent_change <-10 then "Between 10 and 20"
WHEN -30< percent_change <-20 then "Between 20 and 30"
WHEN percent_change <-30 then "more than 30"
else "No discount"
end as discount_rate 
from percent_change_q2
order by discount_rate desc
;

/*question 3*/

/*using the dataset from question 1*/
proc sql;
create table pvstime as
select Configuration, month, mean(Retail_price) as mean_price format dollar6.
from cs2.pos1
group by Configuration,month;
quit;

/*mean price for each configuration*/
proc sql;
create table q3 as
select Configuration, mean(mean_price) as mean_conf_price
from pvstime
group by configuration;
quit;

/*variation among different configurations*/
proc tabulate data = q3;
var mean_conf_price;
table mean_conf_price * (min max range);
run;
/*variation*/
proc sql;
select range(mean_conf_price)/max(mean_conf_price) as variation
from q3;
quit;

/*variation for each month*/
proc sql;
create table q3_2 as
select month, range(Retail_price)/max(Retail_price) as variation
from cs2.pos1
group by month;
quit;


/*Location*/

/*question 1*/

/*creating a new dataset with x and y locations*/
proc sql;
create table loc as
select a.Customer_Postcode, a.Store_Postcode, b.OS_X as Cust_X, b.OS_Y as Cust_Y,
c.OS_X as Store_X, c.OS_Y as Store_Y
from cs2.pos1 as a inner join cs2.LPC as b
on a.Customer_Postcode = b.Postcode
left join cs2.LPC as c 
on a.Store_Postcode = c.Postcode;
quit;
















