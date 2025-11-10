use "C:\Users\amus\Desktop\Kjetil 2025\skijumping_judgestylepoints.dta", clear
*KEEP DATA OF JUMPERS IN WC COMPETITIONS WHO QUALIFIED TO THE SECOND ROUND OF AN EVENT
keep if event_type==1 & eventround==2
bys event_date event_location: keep if _n==1
tab event_countryID
tab event_location
tab event_seasonID
tab event_hillsize
bys event_seasonID: tab event_hillsize

clear
use "C:\Users\amus\Desktop\Kjetil 2025\skijumping_judgestylepoints.dta", clear
keep if event_type==1
egen tag= tag(skijumperID eventID eventround)
levelsof eventID if eventround==2 & tag, local(events)
bys skijumperID eventID event_date: egen dist= total(cond(tag), distancem, .)
bys skijumperID eventID event_date: egen distpoints= total(cond(tag), distancep, .)
bys skijumperID eventID event_date: egen points_style= total(cond(tag), totalstylepoints, .)
bys skijumperID eventID event_date: egen points_wind= total(cond(tag), windpoints, .)
bys skijumperID eventID event_date: egen points_gate= total(cond(tag), gatepoints, .)
gen points_windgate= points_wind + points_gate
keep if eventround==2 & tag
sum WC_points points_comp points_wind points_gate points_windgate points_style dist distpoints points_comp 
bys event_seasonID: sum WC_points points_comp points_wind points_gate points_windgate points_style dist distpoints points_comp 
