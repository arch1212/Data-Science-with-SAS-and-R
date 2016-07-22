/*functions in sas*/
libname class5 '/folders/myfolders/SAS/3';

/*importing the dataset*/
proc import datafile= '/folders/myfolders/SAS/3/Retail_store.csv'
out= class5.retail_stores dbms=csv replace;
getnames=yes; guessingrows= 100;
run;

/*adding column for the averages*/
data store;
set class5.retail_stores;
/*avg_sales = mean(sales_m1, sales_m2, sales_m3, sales_m4,......., sales_m12);*/
avg_sales = mean(of sales_m1 - sales_m12);
sum_sales = sum(of sales_:); /*sum of all the variables where the names start from sales_*/
min_sales = min(of sales_m1 - sales_m12);
max_sales = max(of sales_m1 - sales_m12);
std_sales = std(of sales_m1 - sales_m12);
median_sales = median(of sales_m1 - sales_m12);
range_sales = range(of sales_m1 - sales_m12);
var_sales = var(of sales_m1 - sales_m12);
run;

/*conversion functions in sas*/
data store2;
set class5.retail_stores;
format Profit comma10.;
Profit = input(Latest_Month_Profit, comma10.);
/*convert the Latest_Month_Profit variable to a numerical vairable called Profit with an informat comma10.*/
/*informat: how the data has been read in while format is how the data is displayed*/
/*not overwriting the exisitng variable*/
date1 = put(Store_Launch_Date, date9.);
date2 = put(Store_Expansion_Date, date9.);
ns = put(storesegment, 2.); /*converting the numerical variable to text variable*/
/*in put function, we mention the informat of the numerical variable, while in the input function we mention the informat of the output numerical variable*/
run;
/*they won't show as dates or profit if the format is missing*/

/*more numerical functions*/
data stores3;
set store2;
ABS_Profit = ABS(Profit);
Round_BS = Round(BasketSize);
Int_BS = INT(BasketSize);
CEIL_BS = CEIL(BasketSize);
FLOOR_BS = FLOOR(BasketSize);
run;

/*variations in round function*/
data test;
x = round(223.456);
x2 = round(223.456, 1);
x3 = round(223.456, 10);
x4= round(223.456, 100);
x5 = round(223.456, .1);
x6 = round(223.456, .01);
x7 = round(223.456, 3); /*multiple whichever is closer*/
x8 = round(223.456, 2);
run;


/*Exploring Date and time functions*/
data store4;
set class5.retail_stores;
rename store_launch_date = date1;
rename store_expansion_date = date2;
run;

data store4;
set store4;
keep date1 date2;
run;

data store5;
set store4;
store_launch_year = year(date1);
store_launch_month = month(date1);
store_launch_day = day(date1);
store_launch_weekday = weekday(date1);
store_launch_qtr = qtr(date1);
cur_today = mdy(2,13,2016); /*function to create date, we need to format it as well*/
cur_today1 = today();
cur_now = datetime();
x = datepart(cur_now); /*extracting date part*/
y = timepart(cur_now); /*extracting time part*/
format cur_today date9. cur_now datetime16.;
run;

/*difference between two dates*/
data store6;
set store4;
n_y = intck('year', date1, date2);
n_m = intck('month', date1, date2);
n_q = intck('qtr', date1, date2);
n_w = intck('week', date1, date2);
n_d = intck('day', date1, date2);

n1_y = intnx('year', date1, 2);

o_n = datdif(date1, date2, 'act/act'); /*we want to figure out the difference between actual dates*/
o_n = datdif(date1, date2, '30/360'); /*or you want to standardize the number of days in a month 30 x 12*/
o_n2 = yrdif(date1, date2, 'act/act'); /*actual no of days/no of days in that year*/
o_n3 = yrdif(date1, date2, 'act/act'); /*actual no of days/360*/
run;

/*exploring text functions*/
data store7;
set class5.retail_stores;
keep store_manager_name Location storeid;
run;

data store8;
set store7;
length_name = length(store_manager_name);
length_col = lengthc(store_manager_name);
/*length c gives the length of the variable i.e. the answer will same across all the rows. length will give the length of the cell.*/

name1 = Lowcase(store_manager_name);
name2 = Upcase(store_manager_name);
run;

/*substr, compress*/
data store8;
set store7;
name3 = SUBSTR(store_manager_name,1,5); /*start from the 1st character and extract 5 characters*/
name = compress(store_manager_name, ","); /*this is going to remove the comma ,*/
run;
/*anything that occupies space in the cell is a character*/

/*delimiter in the location*/
data store8;
set store7;
City = SCAN(Location, 1, "-");
Pincode = SCAN(Location,2, "-");
run;

/*using find function to find the position*/
data store8;
set store7;
comma_Position = FIND(store_manager_name, ",");
Hyphen_position = FIND(storeid, "-");
run;

data stores6;
set store7;
Tran_wrd = Tranwrd(storeid, 'STR', 'STORE');
Trans_late = Translate(storeid, '12345', 'ABCDE');
run; 