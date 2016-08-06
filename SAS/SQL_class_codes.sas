libname c7 '/folders/myfolders/SAS/3';
/*basic stuff*/
/*the output will only go to results window*/
proc sql;
select cust_id, aqchannel, marital_status from c7.cust_seg;
quit;

/*creates a table*/
proc sql;
create table temp as select cust_id, aqchannel, marital_status from c7.cust_seg;
quit;

/* * indicates to keep all the variables*/
proc sql;
create table temp as select * from c7.cust_seg;
quit;

/*using where statement*/
proc sql;
create table temp as select * from c7.cust_seg where pre_usage >10;
quit;

/*using distinct*/
proc sql;
select distinct segment  from c7.cust_seg where pre_usage >10;
quit;

/*Computing */
proc sql;
select sum(pre_usage) as total_pre, sum(post_usage_1month) as total_post 
from c7.cust_seg where pre_usage >10;
quit; 

/*column wise and row-wise operations*/
proc sql;
select mean(sum(pre_usage, post_usage_1month, latest_mon_usage, post_usage_2ndmonth)) as total_avg_usage
from c7.cust_seg;
quit;

/*Grouping by a categorical variable*/
proc sql;
select aqchannel, mean(preUsage) as avg_pre from c7.cust_seg group by aqchannel;
quit;

/*we can keep adding more categorical variables*/
proc sql;
select aqchannel,segment, mean(preUsage) as avg_pre from c7.cust_seg group by aqchannel, segment;
quit;

/*or create a table*/
proc sql;
create table temp
as select aqchannel,segment, 
mean(preUsage) as avg_pre 
from c7.cust_seg 
group by aqchannel, segment;
quit;

/*load library for ccu*/
libname c7q '/folders/myfolders/SAS/SQL Class Case';

/*questions from case study 2*/

/*find the top 10 customers*/
proc sql outobs=10; /*to load only 10 observations*/
create table temp
as select custid, sum(expense) as expense
from c7q.ccu 
group by custid
order by expense desc; 
quit;

/*distinct categories*/
proc sql;
create table temp
as select distinct category
from c7q.ccu;
quit;

/*top 3 categories of expense*/
proc sql outobs=3;
create table temp
as select category, sum(expense) as expense
from c7q.ccu
group by category
order by expense desc;
quit;

/*average expense of each customer in the month of September*/
proc sql;
create table temp
as select custid, mean(expense) as expense 
from c7q.ccu
where month(date)=9
/*where will be added just after from statement*/
group by custid;
quit;

/*average, standard deviation for expense across categories*/
proc sql;
create table temp
as select category, std(expense) as sd_expense, mean(expense) as avg_exp
from c7q.ccu
group by category

Union all

select "Overall" as category, std(expense) as sd_exp, avg(expense) as avg_exp
from c7q.ccu
;
quit;

/*How many customers have expense in more than 5 categories*/

proc sql;
select custid, count(distinct category)as dist_cat_count
/*select distinct custid, count(distinct category)as dist_cat_count*/
from c7q.ccu
group by custid
having dist_cat_count>=5;
/*where would always come after from. having is to filter from the final data set.
so it'll be at the end.*/
quit;
/*part b*/
proc sql;
select custid, count(distinct category)as dist_cat_count
from c7q.ccu
group by custid
having dist_cat_count>= (select count(distinct category) from c7q.ccu);
quit;

/*the sum if function*/
/*Objective: create a broad category wrt to values from 'category' variable and then calculate expense for each custid*/
proc sql;
create table cust_pro as select custid,
SUM(CASE WHEN category = 'laptops' or category = 'cellphone' or category = 'tablets' THEN expense ELSE 0 END)
as expense_electronic,
SUM(CASE WHEN category = 'clothes' or category = 'food' or category = 'medicines' THEN expense ELSE 0 END)
as expense_home,
SUM(CASE WHEN category = 'toys' or category = 'club' or category = 'casino' or category = 'books' or category = 'movie' THEN expense ELSE 0 END)
as expense_other

from c7q.ccu
group by custid
order by custid;
quit;

/*merging*/

/*merging gaming 1 and gaming2 with left join*/
proc sql;
create table consolidate as
select gaming1.* gaming2.*
/*we need to prefix the variable with the table name*/
/* * refers to all the variables from gaming1 and gaming2 */

/*use gaming1 and gaming2 and apply the left join on gamer id*/
/*all the gamer ids from gaming1 and the matching information from gaming 2*/
from c7q.gaming1 left join c7q.gaming2 
on gaming1.gamer_id = gaming2_gamer_id;
quit;

/*merging gaming 1 and gaming2 with inner join*/
proc sql;
create table consolidate as
select gaming1.* gaming.*
/*we need to prefix the variable with the table name*/
/* * refers to all the variables from gaming1 and gaming2 */

/*use gaming1 and gaming2 and apply the inner join on gamer id*/
/*all the common gamer ids from gaming1 and gaming 2*/
from c7q.gaming1 inner join c7q.gaming2 
on gaming1.gamer_id = gaming2_gamer_id;
quit;

/*alternate way to avoid writing huge names*/
proc sql;
create table consolidate as
select a.*, b.*
from c7q.gaming1 as a left join c7q.gaming2 as b on a.gamer_id = b.gamer_id;
quit;

/*q0: create a consolidation of all tables with all gamer ids from all tables*/
/*everything from a and matching record from b and c*/
proc sql;
create table consolidated as
select a.*, b.*, c.*
/*first joint b with a and the result should be joined with c*/
from c7q.gaming1 as a left join c7q.gaming2 as b 
on a.gamer_id = b.gamer_id
left join c7q.gaming3 as c 
on a.gamer_id = c.gamer_id;
quit;

/*q1:  Players with mac os who play dota as solo and spend more than 40 minutes per
session on free version of license.*/
proc sql;
create table temp as
select *
from consolidated
where OS = 'mac' and _game_name = 'dota' and 
session_type = 'solo' and license = 'free' and ATPS > 40;
quit;

/*Average time spent and standard deviation of ATPS for each game across OS type
and network speeds*/
proc sql;
select _game_name, os, netspeed, avg(ATPS) as avg_time_spent, std(ATPS) as std_time_spent
from consolidate
group by _game_name, os, netspeed;
quit;

/*Create tables a and b and do all four joins based on game type as id
4. Where tables a and b is as follows:
A: distinct combination of game name, license version and session type present in the
data set only for three games, and not starcraft
B: average time spent per session for each game across network speed and OS only for dota and starcraft*/

/*Table A*/
proc sql;
create table a as
select distinct _game_name, license, session_type
from consolidated
where _game_name ne 'starcraft';
quit;

proc sql;
create table b as 
select distinct _game_name, os, netspeed, avg(ATPS) as avg_time_spent
/*there is no need to use the word distinct when we are using group by*/
from consolidated
where _game_name = "dota" or _game_name = "starcraft"
group by _game_name, netspeed, os;
quit;

/*joints*/
proc sql;
create table inner_joint as
select a.*, b.*
from a inner join b on a._game_name = b._game_name;

create table left_join_joint as
select a.*, b.*
from a left join b on a._game_name = b._game_name;

create table right_joint as
select a.*, b.*
from a right join b on a._game_name = b._game_name;

create table full_joint as
select a.*, b.*
from a full join b on a._game_name = b._game_name;

quit; 




























