cap frame change default
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

keep if tag & eventround==2
gsort eventID -dist
by eventID: gen distrank= _n
by eventID: replace distrank= distrank[_n-1] if dist==dist[_n-1]

gsort eventID -points_dist
by eventID: gen distprank= _n
by eventID: replace distprank= distprank[_n-1] if points_dist==points_dist[_n-1]

gsort eventID -points_style
by eventID: gen stylerank= _n
by eventID: replace stylerank= stylerank[_n-1] if points_style==points_style[_n-1]

gsort eventID -points_wind
by eventID: gen windrank= _n
by eventID: replace windrank= windrank[_n-1] if points_wind==points_wind[_n-1]

gsort eventID -points_gate
by eventID: gen gaterank= _n
by eventID: replace gaterank= gaterank[_n-1] if points_gate==points_gate[_n-1]


gsort eventID -points_windgate
by eventID: gen windgaterank= _n
by eventID: replace windgaterank= windgaterank[_n-1] if points_windgate==points_windgate[_n-1]

frlink m:1 event_date event_location, frame(ranks date location)
frget r2, from(ranks) 
drop ranks

levelsof WC_points if WC_points>0, local(points)
gen dist_points=0 if inlist(distrank, 31, 32)
forval i=30(-1)1{
	replace dist_points = real(word("`points'", `i')) if distrank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen distp_points=0 if inlist(distprank, 31, 32)
forval i=30(-1)1{
	replace distp_points = real(word("`points'", `i')) if distprank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen style_points=0 if inlist(stylerank, 31, 32)
forval i=30(-1)1{
	replace style_points = real(word("`points'", `i')) if stylerank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen wind_points=0 if inlist(windrank, 31, 32)
forval i=30(-1)1{
	replace wind_points = real(word("`points'", `i')) if windrank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen gate_points=0 if inlist(gaterank, 31, 32)
forval i=30(-1)1{
	replace gate_points = real(word("`points'", `i')) if gaterank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen windgate_points=0 if inlist(windgaterank, 31, 32)
forval i=30(-1)1{
	replace windgate_points = real(word("`points'", `i')) if windgaterank==31-`i'
}


gsort eventID -pointsmstyle
by eventID: gen pmsrank= _n
by eventID: replace pmsrank= pmsrank[_n-1] if pointsmstyle==pointsmstyle[_n-1]
gsort eventID -pointsmwind
by eventID: gen pmwrank= _n
by eventID: replace pmwrank= pmwrank[_n-1] if pointsmwind==pointsmwind[_n-1]
gsort eventID -pointsmgate
by eventID: gen pmgrank= _n
by eventID: replace pmgrank= pmgrank[_n-1] if pointsmgate==pointsmgate[_n-1]
gsort eventID -pointsmwindgate
by eventID: gen pmwgrank= _n
by eventID: replace pmwgrank= pmwgrank[_n-1] if pointsmwindgate==pointsmwindgate[_n-1]



levelsof WC_points if WC_points>0, local(points)
gen ms_points=0 if inlist(pmsrank, 31, 32)
forval i=30(-1)1{
	replace ms_points = real(word("`points'", `i')) if pmsrank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen mw_points=0 if inlist(pmwrank, 31, 32)
forval i=30(-1)1{
	replace mw_points = real(word("`points'", `i')) if pmwrank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen mg_points=0 if inlist(pmgrank, 31, 32)
forval i=30(-1)1{
	replace mg_points = real(word("`points'", `i')) if pmgrank==31-`i'
}

levelsof WC_points if WC_points>0, local(points)
gen mwg_points=0 if inlist(pmwgrank, 31, 32)
forval i=30(-1)1{
	replace mwg_points = real(word("`points'", `i')) if pmwgrank==31-`i'
}




collapse (sum) WC_points dist_points distp_points style_points wind_points gate_points windgate_points ms_points mw_points mg_points mwg_points, by(skijumper_name event_seasonID)
gsort event_seasonID -WC_points
by event_seasonID: gen WC_rank= _n
by event_seasonID: replace WC_rank =WC_rank[_n-1] if WC_points==WC_points[_n-1]
gsort event_seasonID -dist_points
by event_seasonID: gen distrank= _n
by event_seasonID: replace distrank=distrank[_n-1] if dist_points==dist_points[_n-1]
gsort event_seasonID -distp_points
by event_seasonID: gen distprank= _n
by event_seasonID: replace distprank=distprank[_n-1] if distp_points==distp_points[_n-1]
gsort event_seasonID -style_points
by event_seasonID: gen stylerank= _n
by event_seasonID: replace stylerank=stylerank[_n-1] if style_points==style_points[_n-1]
gsort event_seasonID -wind_points
by event_seasonID: gen windrank= _n
by event_seasonID: replace windrank=windrank[_n-1] if wind_points==wind_points[_n-1]
gsort event_seasonID -gate_points
by event_seasonID: gen gaterank= _n
by event_seasonID: replace gaterank=gaterank[_n-1] if gate_points==gate_points[_n-1]
gsort event_seasonID -windgate_points
by event_seasonID: gen windgaterank= _n
by event_seasonID: replace windgaterank=windgaterank[_n-1] if windgate_points==windgate_points[_n-1]
gsort event_seasonID -ms_points
by event_seasonID: gen ms_rank= _n
by event_seasonID: replace ms_rank =ms_rank[_n-1] if ms_points==ms_points[_n-1]
gsort event_seasonID -mw_points
by event_seasonID: gen mw_rank= _n
by event_seasonID: replace mw_rank=mw_rank[_n-1] if mw_points==mw_points[_n-1]
gsort event_seasonID -mg_points
by event_seasonID: gen mg_rank= _n
by event_seasonID: replace mg_rank=mg_rank[_n-1] if mg_points==mg_points[_n-1]
gsort event_seasonID -mwg_points
by event_seasonID: gen mwg_rank= _n
by event_seasonID: replace mwg_rank=mwg_rank[_n-1] if mwg_points==mwg_points[_n-1]


foreach var in distrank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))


*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))

}

foreach var in stylerank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))


*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))

}

foreach var in windrank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))


*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))

}

foreach var in gaterank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))


*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))

}

foreach var in windgaterank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))


*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))

}



foreach var in ms_rank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))




*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'


*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))



}

foreach var in mw_rank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))



*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))


}


foreach var in mg_rank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))



*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))


}


foreach var in mwg_rank{

*MEAN ABSOLUTE DEVIATION
gen abs_diff_rank`var' = abs(WC_rank - `var')
bys event_seasonID: egen MAD`var'= mean(abs_diff_rank`var')
sum MAD`var'
display "On average, a jumper's World Cup rank changed by `:di %3.2f `r(mean)'' positions between the original and distance-based ranking."

gr bar MAD`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 3.8))



*SPEARMAN CORRELATION
spearman WC_rank `var'
bys event_seasonID: spearman WC_rank `var'

*KENDALL'S TAU
ktau WC_rank `var'
bys event_seasonID: ktau WC_rank `var'

*ROOT MEAN SQUARED ERROR RANKS
gen squared_diff_rank`var' = (WC_rank - `var')^2
bys event_seasonID: egen MSER`var'= mean(squared_diff_rank`var')
replace MSER`var'= sqrt(MSER`var')
sum MSER`var'
display `"The typical "error" in World Cup rank is `:di %3.2f `r(mean)'' positions, with larger errors contributing disproportionately."'

gr bar MSER`var', over(event_seasonID, relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f)) ylab("") ytitle("") title(Root Mean Squared Error (RMSE) of Ranks) b1title(Season) ysc(range(. 5.0))


}

gr bar MADdist MADstyle MADwindr MADgate MADwindgate  MADms MADmw_r MADmg MADmwg , over(event_seasonID,  relabel(1 "2010-11" 2 "2011-12" 3 "2012-13" 4 "2013-14" 5 "2014-15" 6 "2015-16" 7 "2016-17")) blab(total, format(%3.2f) size(vsmall)) ylab("") ytitle("") title(Mean Absolute Deviation (MAD) of Ranks) b1title(Season) ysc(range(. 1.9)) leg(order(1 "Distance (m)" 2 "Style Points" 3 "Wind Compensation" 4 "Gate Points" 5 "Wind + Gate" 6 "Excluding Style Points" 7 "Excluding Wind Compensation" 8 "Excluding Gate Points" 9 "Excluding Wind + Gate") ring(0) pos(2)) bar(3, color(stc7))

reshape long MAD MSER, i(skijumper_name event_seasonID) j(which) string
replace which = "Distance (Meters)" if which=="distrank"
replace which = "Style Points" if which=="stylerank"
replace which = "Wind Compensation" if which=="windrank"
replace which = "Gate Points" if which=="gaterank"
replace which = "Wind + Gate" if which=="windgaterank"
replace which = "Excl. Style Points"  if which=="ms_rank"
replace which = "Excl. Wind Comp."  if which=="mw_rank"
replace which = "Excl. Gate Points"  if which=="mg_rank"
replace which = "Excl. Wind + Gate"  if which=="mwg_rank"

gen which2=1 if which== "Excl. Gate Points"
replace which2=2 if which=="Excl. Style Points"
replace which2=3 if which=="Excl. Wind Comp."
replace which2=4 if which=="Excl. Wind + Gate"
replace which2=5 if which== "Distance (Meters)"
replace which2=6 if which== "Style Points"
replace which2=7 if which== "Gate Points"
replace which2=8 if which==  "Wind + Gate"
replace which2=9 if which== "Wind Compensation"
labmask which2, values(which)



collapse MAD MSER, by(which2 event_seasonID)
rename (MAD MSER) val=
reshape long val, i(which event_seasonID) j(stat) string
replace stat= "Mean Absolute Deviation (MAD)" if stat=="MAD"
replace stat= "Root Mean Squared Error (RMSE)" if stat=="MSER"
tabplot which event_seasonID [iw=val] if regexm(stat,"MAD"), sort  title("World Cup Ranks vs. Calculated Ranks") subtitle("Mean Absolute Deviation (MAD)") separate(which) showval(format(%3.2f) offset(.15)) ytitle("") xtitle("Season") xlab(1 "2010/11" 2 "2011/12" 3 "2012/13" 4 "2013/14" 5 "2014/15" 6 "2015/16" 7 "2016/17") height(0.715) bar1(color(stc1)) bar2(color(stc1)) bar3(color(stc1)) bar4(color(stc1))  bar5(color(black%70)) bar6(color(stc2)) bar7(color(stc2)) bar8(color(stc2)) bar9(color(stc2)) leg(on order(5 "Exclusion-based" 7 "Distance" 11 "Subjective/compensatory") pos(6) row(1))
graph export stats3.png, replace width(1200) height(800)

tabplot which event_seasonID [iw=val] if regexm(stat,"RMSE"), sort  title("World Cup Ranks vs. Calculated Ranks") subtitle("Root Mean Squared Error (RMSE)") separate(which) showval(format(%3.2f) offset(.15)) ytitle("") xtitle("Season") xlab(1 "2010/11" 2 "2011/12" 3 "2012/13" 4 "2013/14" 5 "2014/15" 6 "2015/16" 7 "2016/17") height(0.715) bar1(color(stc1)) bar2(color(stc1)) bar3(color(stc1)) bar4(color(stc1))  bar5(color(black%70)) bar6(color(stc2)) bar7(color(stc2)) bar8(color(stc2)) bar9(color(stc2)) leg(on order(5 "Exclusion-based" 7 "Distance" 11 "Subjective/compensatory") pos(6) row(1))
graph export stats4.png, replace width(1200) height(800)
