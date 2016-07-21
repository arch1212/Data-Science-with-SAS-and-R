libname a2 '/folders/myfolders/a2';

/*question 1*/
/*importing data from excel*/
proc import datafile= '/folders/myfolders/A2/Grocery_Coupons'
out=a2.grocou dbms = xls replace;
sheet='Data'; getnames=yes;
run;

/*creating new formats*/
proc format;
VALUE Health_food_store
0='NO'
1='YES';

VALUE Size_of_Store
1='SMALL'
2='MEDIUM'
3='LARGE';

VALUE Store_org
1='Emphasizes produce'
2='Emphasizes deli'
3='Emphasizes bakery'
4='No emphasis';

VALUE Gndr
0='Male'
1='Female';

VALUE Shpfr
1='Self'
2='Self and spouse'
3='Self and family';

VALUE Vg
0='NO'
1='YES';

VALUE Styl
1 = 'Biweekly, in bulk'
2 = 'Weekly, similar items'	
3 = 'Often, what is on sale';

VALUE Uscp
1='No'	
2='From newspaper'	
3='From mailings'
4='From both';

VALUE Crry
0='First period'	
1='No coupon'
2='5 percent'	
3='15 percent'	
4 ='25 percent';

VALUE Cpvl
1='No value'	
2='5 percent'	
3='15 percent'	
4='25 percent';

run;

/*variable and value labels*/
data a2.grocou_lab;
set a2.grocou;
label storeid = "Store ID";
label hlthfood= "Health food store";
label size="Size of store";
label org="Store organization";
label custid =	"Customer ID";
label gender = 	"Gender";
label shopfor	= "Who shopping for";
label veg	="Vegetarian";
label style= "Shopping style";
label usecoup="Use coupons";
label week	="Week";
label seq="Sequence";
label carry	= "Carryover";
label coupval = "Value of coupon";
label amtspent	= "Amount spent";
format hlthfood Health_food_store.; 
format size Size_of_Store.; 
format org Store_org.; 
format gender Gndr.; 
format shopfor Shpfr.; 
format veg Vg.; 
format style Styl.; 
format usecoup Uscp.; 
format carry Crry.;
format coupval Cpvl.;
run;

/*question 2*/
proc freq data=a2.grocou;
table coupval style;
run;

/*removing missing gender values*/
data grocou_cleaned;
set a1.grocou;
where gender ^= .;
run;

/*sorting the data by gender*/
proc sort data= grocou_cleaned;
by gender;
run;

proc freq data=grocou_cleaned;
tables coupval style;
by gender;
run;

/*question 3*/
proc freq data = a2.grocou;
table size*org/norow nocol nopercent;
run;

proc freq data = a2.grocou;
table size*org/norow nocol nofreq;
run;

/*question 4*/
proc means data = a2.grocou mean min max var sum;
var amtspent;
run;

proc means data = a2.grocou mean min max var sum;
var amtspent;
class size;
run;

proc means data = a2.grocou mean min max var sum;
var amtspent;
class org;
run;
