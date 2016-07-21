libname a4 '/folders/myfolders/a4';


/*question1*/
/*simple interest*/
data a4.q1a;
amount = 5000;
do years = 15 to 1 by -1;
	interest = amount*0.10*years;
	earned +interest;
	output;
end;
run;

/*compound interest*/
data a4.q1b;
	do year = 1 to 15;
	amount+5000;
	interest = amount*0.10;
	amount + interest;
	output;
end;
run;

/*question 2*/

/*increment the fuel*/
data a3.carmlg;
mlg = 20;
	do until(mls >= 250 or fuel >= 10);
	fuel+1;
	mls = mlg*fuel; 
	fuel + mls/mlg;
	output;
end;
run;

/*question 3*/
data a3.comannual;
amount = 500000;
	do year = 1 to 25;
	 amount + amount*0.07;
	output;
end;
run;
	
data a3.common;
amount = 500000;	
rate = 0.07/12;
	do year = 1 to 25;
		do month = 1 to 12;
		amount + amount*rate;
		output;
		end;
	end;
run;		
	