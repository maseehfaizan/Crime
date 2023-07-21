
/// Master do file for Applied Econometrics Course Project
/// Created on the 21 of November 2022 by Ahmad Maseeh Faizan and Lin Zhu
/// Using main data set of Faizan_Zhu.dta that comes from Campus.dta

clear all

log using Faizan_Zhu.log, replace

use Faizan_Zhu.dta
/// Here, we are plotting the scatter plot with red points when the college is public
/// and red when the college is private to have a visual representation

scatter police crime

twoway	(scatter police crime if priv == 0, mcolor(red)) ///
		(scatter police crime if priv == 1, mcolor(blue)) ///
		, ytitle(Employed Officers) xtitle(Total Campus Crimes) ///
		legend(label( 1 "Public college") label( 2 "Privat college" )) ///

/// Here, we are plotting the scatter plot with green points when the college is large
/// and red when the college is public to have a visual representation, the number 16000
/// is vers close to the mean of number of enroll in our data set at 16076

twoway	(scatter police crime if enroll > 16000, mcolor(green)) ///
		(scatter police crime if enroll < 16000, mcolor(black)) ///
		, ytitle(Employed Officers) xtitle(Total Campus Crimes) ///
		legend(label( 1 "Large Colleges") label( 2 "Small college")) ///

scatter 


/// Here we are generatin a new dummy variable = 1 when the # of enroll is large
/// and 0 when # of enroll is small we chose again 16000 because it is close to the mean
/// Since the Variables are already defined there is no need to run the code again.
gen hcoll = 1
replace hcoll = 0 if enroll < 16000
label variable hcoll "= 1 if total enrollment large"

/// for our table we are generating crime squared to check whether the regression is linear
gen crime2 = crime*crime
label variable crime2  "crime squared"

gen crime3 = crime2*crime
label variable crime3  "crime cube"



gen enroll2 = enroll * enroll
label variable enroll2 "enroll squared"




/// Here we are quietly regressing our variable and storing them to be used on a table
qui reg police crime, r
estimates store e1
qui reg police crime i.priv, r
estimates store e2
qui reg police crime i.priv##i.hcoll , r
estimates store e3
qui reg police crime i.priv##i.hcoll lcrime crime2 ,r
estimates store e4
qui reg police crime enroll lenroll enroll2 i.priv##i.hcoll , r
estimates store e5
qui reg police crime lcrime enroll lenroll crime2 i.priv##i.hcoll enroll2, r
estimates store e6

etable, column(index) estimates(e1 e2 e3 e4 e5 e6) showstars showstarsnote /// 
title(Regression of Police officers employed)

test crime2 lcrime
test enroll2 lenroll

log close

