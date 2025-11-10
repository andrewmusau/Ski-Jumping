cap frame change default
tempfile ranks2 ranks3 ranks4 ranks5 ranks6 ranks7 ranks8 ranks9 ranks10
use "C:\Users\amus\Desktop\Kjetil 2025\skijumping_judgestylepoints.dta", clear
keep if event_type==1
egen tag= tag(skijumperID eventID eventround)
levelsof eventID if eventround==2 & tag, local(events)
bys skijumperID eventID event_date: egen dist= total(cond(tag), distancem, .)
bys skijumperID eventID event_date: egen points_dist= total(cond(tag), distancep, .)
bys skijumperID eventID event_date: egen points_style= total(cond(tag), totalstylepoints, .)
bys skijumperID eventID event_date: egen points_wind= total(cond(tag), windpoints, .)
bys skijumperID eventID event_date: egen points_gate= total(cond(tag), gatepoints, .)
bys skijumperID eventID event_date: gen points_windgate= points_wind+points_gate
gen pointsmstyle= points_comp - points_style
gen pointsmwind= points_comp - points_wind
gen pointsmgate= points_comp - points_gate
gen pointsmwindgate= points_comp - points_windgate
foreach var of varlist event_type event_hillsize event_countryID{
	decode `var', gen(str`var')
}
set trace off
cap frame drop ranks
frame create ranks str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp dist if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[dist]') (`e(r2)')
}
frame change ranks
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and distance regressions)
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and distance regressions)

cap frame drop res
frame create res str100(description) double(N mean sd min max) 
qui sum r2
frame post res ("Jump Distance (Meters)") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')

cap frame change default
cap frame drop ranks10
frame create ranks10 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp points_dist if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks10 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[points_dist]') (`e(r2)')
}
frame change ranks10
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and distance points regressions)
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and distance points regressions)

qui sum r2
frame post res ("Distance Points") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')

cap frame change default
cap frame drop ranks2
frame create ranks2 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp pointsmstyle if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks2 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[pointsmstyle]') (`e(r2)')
}
frame change ranks2
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and points excluding wind compenstation regressions)
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and points excluding wind compensation regressions)

qui sum r2
frame post res ("Excl. Wind Comp.") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')


cap frame change default

cap frame drop ranks3
frame create ranks3 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 

foreach event of local events{
	regress rank_comp pointsmwind if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks3 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[pointsmwind]') (`e(r2)')
}
frame change ranks3
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and points excluding style regressions)

hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and points excluding style regressions)

qui sum r2
frame post res ("Excl. Style Points") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')


cap frame change default

cap frame drop ranks6
frame create ranks6 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 

foreach event of local events{
	regress rank_comp pointsmgate if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks6 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[pointsmgate]') (`e(r2)')
}
frame change ranks6
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and points excluding gate points regressions)
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and points excluding gate points regressions)
qui sum r2
frame post res ("Excl. Gate Points") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')


cap frame change default

cap frame drop ranks8
frame create ranks8 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 

foreach event of local events{
	regress rank_comp pointsmwindgate if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks8 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[pointsmwindgate]') (`e(r2)')
}
frame change ranks8
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and points excluding wind+gate points regressions)
hist r2, start(0.1) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and points excluding wind+gate points regressions)

qui sum r2
frame post res ("Excl. Wind & Gate") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')

cap frame change default
cap frame drop ranks4
frame create ranks4 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp points_style if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks4 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[points_style]') (`e(r2)')
}
frame change ranks4
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and style points regressions)
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and style points regressions)

qui sum r2
frame post res ("Style Points") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')


cap frame change default
cap frame drop ranks5
frame create ranks5 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp points_wind if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks5 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[points_wind]') (`e(r2)')
}
frame change ranks5
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and wind points regressions)
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and wind points regressions)

qui sum r2
frame post res ("Wind Compensation") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')

cap frame change default
cap frame drop ranks7
frame create ranks7 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp points_gate if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks7 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[points_gate]') (`e(r2)')
}
frame change ranks7
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and gate points regressions)
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and gate points regressions)

qui sum r2
frame post res ("Gate Points") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')


cap frame change default
cap frame drop ranks9
frame create ranks9 str30(type) double(date) str30(location country hillsize)  double(hillsize_m constant distance r2) 
foreach event of local events{
	regress rank_comp points_windgate if eventID==`event' & eventround==2 & tag
	foreach var of varlist str* {
	    levelsof `var' if eventID==`event'  & eventround==2 & tag,  local(`=substr("`var'", 4, .)') clean
		di "`var' = ``var''"
	}
	foreach var in location date hillsize_m{
	    levelsof event_`var' if eventID==`event'  & eventround==2 & tag,  local(`var') clean
		di "`var' = ``var''"
	}
	frame post ranks9 ("`event_type'") (`date') ("`location'") ("`event_countryID'") ("`event_hillsize'") (`hillsize_m') (`=_b[_cons]') (`=_b[points_windgate]') (`e(r2)')
}
frame change ranks9
hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels freq title(Rank and wind+gate points regressions)

hist r2, start(0) width(0.1) xlab(0.1(0.1)1) xsc(r(0.1 1)) xtitle(R-squared) addlabels addlabopts(mlabformat(%3.2f)) percent title(Rank and wind+gate points regressions)

qui sum r2
frame post res ("Wind & Gate") (`r(N)') (`r(mean)') (`r(sd)') (`r(min)') (`r(max)')


frame ranks2{
	gen which= "Total Points Excluding Style Points"
	save `ranks2', replace
}

frame ranks3{
	gen which= "Total Points Excluding Wind Compensation"
	save `ranks3', replace
}

frame ranks6{
	gen which= "Total Points Excluding Gate Points"
	save `ranks6', replace
}

frame ranks8{
	gen which= "Total Points Excluding Wind & Gate Points"
	save `ranks8', replace
}

frame ranks4{
	gen which= "Style Points"
	save `ranks4', replace
}

frame ranks5{
	gen which= "Wind Compensation"
	save `ranks5', replace
}


frame ranks7{
	gen which= "Gate Points"
	save `ranks7', replace
}

frame ranks9{
	gen which= "Wind Compensation & Gate Points"
	save `ranks9', replace
}



frame change ranks
append using `ranks2'
append using `ranks3'
append using `ranks6'
append using `ranks8'
append using `ranks4'
append using `ranks5'
append using `ranks7'
append using `ranks9'

replace which= "Jump Distance (Meters)" if which==""

cap drop which2
gen which2= cond(ustrregexm(which, "Meters"), 1, cond(ustrregexm(which, "\bExcluding Style\b"), 2, cond(ustrregexm(which, "\bExcluding Wind Compensation\b"), 3, cond(ustrregexm(which, "\bExcluding Gate\b"), 4, cond(ustrregexm(which, "\bExcluding Wind \& Gate\b"), 5, cond(which== "Style Points", 6, cond(which== "Wind Compensation", 7, cond(which== "Gate Points", 8, 9))))))))
			
labmask which2, values(which)



hist r2, by(which2, title("Distribution of R-squared from Univariate Regressions of Rank" "on Various Score Components ({it:n} = 151 World Cup Events)", size(medlarge)) note("") leg(off) col(1) noiylabel noiyticks) start(0) width(0.1) xlab(0(0.1)1) xsc(r(0 1)) percent ysc(r(. 113.5)) ylab("") xtitle(R-squared) addlabels plotregion(margin(zero)) ysize(12) 


local colors black%70 stc1 stc1 stc1 stc1 stc2 stc2 stc2 stc2
forval i =1/9{
    gr_edit .plotregion1.plotregion1[`i'].plot1.EditCustomStyle , j(-1) style(area(shadestyle(color(`=word("`colors'", `i')'))))	
    gr_edit .plotregion1.plotregion1[`i'].plot1.EditCustomStyle , j(-1) style(area(linestyle(color(white))))	
}



graph export r2_all.png, replace width(4000) height(4000)


frame change res
gr hbar mean, over(desc, sort(1) gap(8)) ylab(none) ytitle("") blab(total, format(%3.2f)) title("Mean R-squared by Component ({it:n} = 151 Events)") ysc(r(. 1.01)) bar(1, blcolor(black) fcolor(black%70)) bar(7, blcolor(black) fcolor(black%70)) bar(2, blcolor(black) bcolor(stc1)) bar(3, blcolor(black) bcolor(stc1)) bar(4, blcolor(black) bcolor(stc1)) bar(5, blcolor(black) bcolor(stc1)) bar(6, blcolor(black) bcolor(stc2)) bar(8, blcolor(black) bcolor(stc2)) bar(9, blcolor(black) bcolor(stc2)) bar(10, blcolor(black) bcolor(stc2))asyvars showyvars legend(order(2 "Exclusion-based" 1 "Distance" 9 "Subjective/compensatory") pos(6) row(1))
graph export meanr2_all.png, replace width(3000) height(1900)
