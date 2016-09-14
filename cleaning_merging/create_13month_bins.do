
* Set this to ERAI/GMFD/NCEP/CFSR
local clim "BEST"
* Set directory accordingly
local baseDir "/mnt/norgay_gcp/Summer-Workshop-Data/_spatial_data"
local usaDir "`baseDir'/USA/gz_2010_us_050_00_500k/USA_FIPS/cleaned"
local fraDir "`baseDir'/FRA/test_FRA_adm2/cleaned"
local braDir "`baseDir'/BRA/test_BRA_adm2/cleaned"
local mexDir "`baseDir'/MEX/test_MEX/cleaned"
*local chnDir "`baseDir'/CHN/test_CHN/cleaned"
local chnDir "~/Dropbox/ChicagoRAs_Reanalysis/interpolation/Ishan_Code/China/Climate"
local indDir "/home/solomon/Dropbox/GCP/Summer-Workshop-Data/_spatial_data/IND_1961/test_IND_1961/weather_data"

local usaVar "STATE_COUNTY"
local fraVar "NAME_1_NAME_2"
local braVar "NAME_1_NAME_2"
local mexVar "NOM_ENT_NOM_MUN"
*local chnVar "NAME_1_NAME_2"
local chnVar "CNTYGB"
local indVar "DIST61_ID"


*********************
*   USA, FRA   *
/*
foreach cntry in usa fra {
local cntryDir "``cntry'Dir'"
local adminVar "``cntry'Var'"
di "`adminVar'"
di "`cntryDir'"
cap mkdir "`cntryDir'/dta"

* Bottom bin cutoff
local realbot = -40
local top = 35
local mid = -1
local inc = 1
local bot = `realbot'-`inc'

**** Combine monthly bins into annual
local init = 1
local arealist
local poplist
local croplist
local arealist13
local poplist13
local croplist13

forvalues i = `bot'(`inc')`top' {

	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			if `i' == `bot' {
				local cutoffs "nInf_n`hi'C"
			}
			else {
				local cutoffs "n`lo'C_n`hi'C"
			}
		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	
	if `init' {
	use "`cntryDir'/`clim'_tavg_BIN_`cutoffs'.dta", clear
	duplicates drop `adminVar' year, force
	local init = 0
	
	}
	else {
	preserve
	use "`cntryDir'/`clim'_tavg_BIN_`cutoffs'.dta", clear
	duplicates drop `adminVar' year, force
	tempfile temp
	save `temp', replace
	restore
	merge 1:1 `adminVar' year using `temp', nogen
	}
	cap drop tavg_bin_*_JJA_* tavg_bin_*_SON_* tavg_bin_*_DJF_* tavg_bin_*_MAM_* tavg_bin_*_annual_* tavg_bin_*_NH_*
	
	foreach weight in area pop crop {
	
	local bin "tavg_bin_`cutoffs'_`weight'"
	egen `bin' = rowtotal(tavg_bin_`cutoffs'_m*_`weight')
	local `weight'list ``weight'list' `bin'
	
	egen admin_unit = group(`adminVar')
	xtset admin_unit year
	local bin13 "tavg_bin13_`cutoffs'_`weight'"
	gen `bin13' = `bin' + L.tavg_bin_`cutoffs'_m12_`weight'
	replace `bin13' = `bin' if `bin13' == .
	xtset, clear
	drop admin_unit
	local `weight'list13 ``weight'list13' `bin13'
	
	drop *_m*_`weight'
	}
}

order year `adminVar' `poplist' `arealist' `croplist' `poplist13' `arealist13' `croplist13'
****

**** Create 5C bins
foreach bin in bin bin13 {
	foreach weight in area pop crop {
	
	local binlist
	forvalues i = -41(1)35 {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			if `i' == `bot' {
				local cutoffs "nInf_n`hi'C"
			}
			else {
				local cutoffs "n`lo'C_n`hi'C"
			}
		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	cap gen tavg_`bin'_`cutoffs'_`weight' = 0
	local binvar tavg_`bin'_`cutoffs'_`weight'
	local binlist `binlist' `binvar'
	}
	
	order `binlist'
	
	* bottom bin
	egen `bin'_nInf_n17C_`weight' = rowtotal(tavg_`bin'_nInf_n40C_`weight'-tavg_`bin'_n18C_n17C_`weight')

	* negative values
	foreach i of numlist 12 7 2 {
		loc lb = `i'+5 
		loc lbplus = `lb'-1 
		loc ub = `i'
		loc ubminus = `ub' +1
		egen `bin'_n`lb'C_n`ub'C_`weight' = rowtotal(tavg_`bin'_n`lb'C_n`lbplus'C_`weight' - tavg_`bin'_n`ubminus'C_n`ub'C_`weight')
		}

	* crossing zero
	egen `bin'_n2C_3C_`weight' = rowtotal(tavg_`bin'_n2C_n1C_`weight'-tavg_`bin'_2C_3C_`weight')

	* positive values
	foreach i of numlist 3(5)28 {
		loc lb = `i'
		loc lbplus = `lb'+1
		loc ub = `i'+ 5
		loc ubminus = `ub' -1
		egen `bin'_`lb'C_`ub'C_`weight' = rowtotal(tavg_`bin'_`lb'C_`lbplus'C_`weight' - tavg_`bin'_`ubminus'C_`ub'C_`weight')
		}
		
	* top bin
	egen `bin'_33C_Inf_`weight' = rowtotal(tavg_`bin'_33C_34C_`weight' - tavg_`bin'_35C_Inf_`weight')
	}
}
****

**** Create bins (pop weighted) with cutoffs that correspond roughly to 10F intervals
local weight "pop"
egen bin1 = rowtotal(tavg_bin_nInf_n40C_`weight'-tavg_bin_n13C_n12C_`weight')
egen bin2 = rowtotal(tavg_bin_n12C_n11C_`weight'-tavg_bin_n7C_n6C_`weight')
egen bin3 = rowtotal(tavg_bin_n6C_n5C_`weight'-tavg_bin_n2C_n1C_`weight')
egen bin4 = rowtotal(tavg_bin_n1C_0C_`weight'-tavg_bin_4C_5C_`weight')
egen bin5 = rowtotal(tavg_bin_5C_6C_`weight'-tavg_bin_9C_10C_`weight')
egen bin6 = rowtotal(tavg_bin_10C_11C_`weight'-tavg_bin_14C_15C_`weight')
egen bin7 = rowtotal(tavg_bin_15C_16C_`weight'-tavg_bin_20C_21C_`weight')
egen bin8 = rowtotal(tavg_bin_21C_22C_`weight'-tavg_bin_25C_26C_`weight')
egen bin9 = rowtotal(tavg_bin_26C_27C_`weight'-tavg_bin_31C_32C_`weight')
egen bin10 = rowtotal(tavg_bin_32C_33C_`weight'-tavg_bin_35C_Inf_`weight')

**** Save
save "`cntryDir'/`clim'_tempbins_with_13month_formerge.dta", replace
****

  * Done *
*************

}
*/

local cntry chn
local cntryDir "``cntry'Dir'"
local adminVar "``cntry'Var'"
di "`adminVar'"
di "`cntryDir'"


* Bottom bin cutoff
local realbot = -40
local top = 35
local mid = -1
local inc = 1
local bot = -20

**** Save as .dta
forvalues i = `bot'(`inc')`top' {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			
				local cutoffs "n`lo'C_n`hi'C"

		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	*local cutoffs = subinstr("`cutoffs'","-","",.)
	import delimited "`cntryDir'/`clim'_tavg_BIN_`cutoffs'.csv", case(preserve) encoding("latin1") clear
	duplicates drop `adminVar' year, force
	tempfile `clim'_tavg_BIN_`cutoffs'
	save ``clim'_tavg_BIN_`cutoffs'', replace
	*save "`cntryDir'/`clim'_tavg_BIN_`cutoffs'.dta", replace
}
****



**** Combine monthly bins into annual
local init = 1
local arealist
local poplist
local croplist
local arealist13
local poplist13
local croplist13

forvalues i = `bot'(`inc')`top' {

	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+`inc')
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			
				local cutoffs "n`lo'C_n`hi'C"
			
		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	
	if `init' {
	use ``clim'_tavg_BIN_`cutoffs'.dta', clear
	duplicates drop `adminVar' year, force
	local init = 0
	
	}
	else {
	preserve
	use ``clim'_tavg_BIN_`cutoffs'.dta', clear
	duplicates drop `adminVar' year, force
	tempfile temp
	save `temp', replace
	restore
	merge 1:1 `adminVar' year using `temp', nogen
	}
	cap drop tavg_bin_*_JJA_* tavg_bin_*_SON_* tavg_bin_*_DJF_* tavg_bin_*_MAM_* tavg_bin_*_annual_* tavg_bin_*_NH_*
	* capitalize to match other files
	cap rename *c_* *C_*
	cap rename *inf* *Inf*
	cap rename *InfC_* *Inf_*
	
	*foreach weight in area pop crop {
	foreach weight in pop {
	local bin "tavg_bin_`cutoffs'_`weight'"
	egen `bin' = rowtotal(tavg_bin_`cutoffs'_m*_`weight')
	local `weight'list ``weight'list' `bin'
	
	egen admin_unit = group(`adminVar')
	xtset admin_unit year
	local bin13 "tavg_bin13_`cutoffs'_`weight'"
	gen `bin13' = `bin' + L.tavg_bin_`cutoffs'_m12_`weight'
	replace `bin13' = `bin' if `bin13' == .
	xtset, clear
	drop admin_unit
	local `weight'list13 ``weight'list13' `bin13'
	
	drop *_m*_`weight'
	}
}

order year `adminVar' `poplist' `arealist' `croplist' `poplist13' `arealist13' `croplist13'
****


**** Create 5C bins
foreach bin in bin bin13 {
	*foreach weight in area pop crop {
	foreach weight in pop {
	
	local binlist
	forvalues i = -41(1)35 {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			if `i' == -41 {
				local cutoffs "nInf_n`hi'C"
			}
			else {
				local cutoffs "n`lo'C_n`hi'C"
			}
		}
		else {
			if `i' == 35 {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	cap gen tavg_`bin'_`cutoffs'_`weight' = 0
	local binvar tavg_`bin'_`cutoffs'_`weight'
	local binlist `binlist' `binvar'
	}
	
	order `binlist'
	
	* bottom bin
	egen `bin'_nInf_n17C_`weight' = rowtotal(tavg_`bin'_nInf_n40C_`weight'-tavg_`bin'_n18C_n17C_`weight')

	* negative values
	foreach i of numlist 12 7 2 {
		loc lb = `i'+5 
		loc lbplus = `lb'-1 
		loc ub = `i'
		loc ubminus = `ub' +1
		egen `bin'_n`lb'C_n`ub'C_`weight' = rowtotal(tavg_`bin'_n`lb'C_n`lbplus'C_`weight' - tavg_`bin'_n`ubminus'C_n`ub'C_`weight')
		}

	* crossing zero
	egen `bin'_n2C_3C_`weight' = rowtotal(tavg_`bin'_n2C_n1C_`weight'-tavg_`bin'_2C_3C_`weight')

	* positive values
	foreach i of numlist 3(5)28 {
		loc lb = `i'
		loc lbplus = `lb'+1
		loc ub = `i'+ 5
		loc ubminus = `ub' -1
		egen `bin'_`lb'C_`ub'C_`weight' = rowtotal(tavg_`bin'_`lb'C_`lbplus'C_`weight' - tavg_`bin'_`ubminus'C_`ub'C_`weight')
		}
		
	* top bin
	egen `bin'_33C_Inf_`weight' = rowtotal(tavg_`bin'_33C_34C_`weight' - tavg_`bin'_35C_Inf_`weight')
	}
}
****

**** Create bins (pop weighted) with cutoffs that correspond roughly to 10F intervals
local weight "pop"
egen bin1 = rowtotal(tavg_bin_nInf_n40C_`weight'-tavg_bin_n13C_n12C_`weight')
egen bin2 = rowtotal(tavg_bin_n12C_n11C_`weight'-tavg_bin_n7C_n6C_`weight')
egen bin3 = rowtotal(tavg_bin_n6C_n5C_`weight'-tavg_bin_n2C_n1C_`weight')
egen bin4 = rowtotal(tavg_bin_n1C_0C_`weight'-tavg_bin_4C_5C_`weight')
egen bin5 = rowtotal(tavg_bin_5C_6C_`weight'-tavg_bin_9C_10C_`weight')
egen bin6 = rowtotal(tavg_bin_10C_11C_`weight'-tavg_bin_14C_15C_`weight')
egen bin7 = rowtotal(tavg_bin_15C_16C_`weight'-tavg_bin_20C_21C_`weight')
egen bin8 = rowtotal(tavg_bin_21C_22C_`weight'-tavg_bin_25C_26C_`weight')
egen bin9 = rowtotal(tavg_bin_26C_27C_`weight'-tavg_bin_31C_32C_`weight')
egen bin10 = rowtotal(tavg_bin_32C_33C_`weight'-tavg_bin_35C_Inf_`weight')

**** Save
save "`cntryDir'/`clim'_tempbins_with_13month_formerge.dta", replace
****

  * Done *
*************




/*
************
* BRA, MEX *
************
foreach cntry in bra mex {
local cntryDir ``cntry'Dir'
local adminVar ``cntry'Var'

cap mkdir "`cntryDir'/dta"

* Bottom bin cutoff
local realbot = -40
local top = 35
local mid = -1
local inc = 1
local bot = 0

**** Combine monthly bins into annual
local init = 1
local arealist
local poplist
local croplist
local arealist13
local poplist13
local croplist13
forvalues i = `bot'(`inc')`top' {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			if `i' == `bot' {
				local cutoffs "nInf_n`hi'C"
			}
			else {
				local cutoffs "n`lo'C_n`hi'C"
			}
		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	if `init' {
	use "`cntryDir'/`clim'_tavg_BIN_`cutoffs'.dta", clear
	duplicates drop `adminVar' year, force
	local init = 0
	}
	else {
	preserve
	use "`cntryDir'/`clim'_tavg_BIN_`cutoffs'.dta", clear
	duplicates drop `adminVar' year, force
	tempfile temp
	save `temp', replace
	restore
	merge 1:1 `adminVar' year using `temp', nogen
	}
	
	foreach weight in area pop crop {
	local bin "tavg_bin_`cutoffs'_`weight'"
	egen `bin' = rowtotal(tavg_bin_`cutoffs'_m*_`weight')
	local `weight'list ``weight'list' `bin'
	
	egen admin_unit = group(`adminVar')
	xtset admin_unit year
	local bin13 "tavg_bin13_`cutoffs'_`weight'"
	gen `bin13' = `bin' + L.tavg_bin_`cutoffs'_m12_`weight'
	replace `bin13' = `bin' if `bin13' == .
	xtset, clear
	drop admin_unit
	local `weight'list13 ``weight'list13' `bin13'
	
	drop *_m*_`weight'
	}
}

order year `adminVar' `poplist' `arealist' `croplist' `poplist13' `arealist13' `croplist13'
****

**** Create 5C bins
local top = 35
local mid = -1
local inc = 1
local bot = -41
foreach bin in bin bin13 {
	foreach weight in area pop crop {
	
	local binlist
	forvalues i = -41(1)35 {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			if `i' == `bot' {
				local cutoffs "nInf_n`hi'C"
			}
			else {
				local cutoffs "n`lo'C_n`hi'C"
			}
		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	cap gen tavg_`bin'_`cutoffs'_`weight' = 0
	local binvar tavg_`bin'_`cutoffs'_`weight'
	local binlist `binlist' `binvar'
	}
	
	order `binlist'
	
	* bottom bin
	egen `bin'_nInf_n17C_`weight' = rowtotal(tavg_`bin'_nInf_n40C_`weight'-tavg_`bin'_n18C_n17C_`weight')

	* negative values
	foreach i of numlist 12 7 2 {
		loc lb = `i'+5 
		loc lbplus = `lb'-1 
		loc ub = `i'
		loc ubminus = `ub' +1
		egen `bin'_n`lb'C_n`ub'C_`weight' = rowtotal(tavg_`bin'_n`lb'C_n`lbplus'C_`weight' - tavg_`bin'_n`ubminus'C_n`ub'C_`weight')
		}

	* crossing zero
	egen `bin'_n2C_3C_`weight' = rowtotal(tavg_`bin'_n2C_n1C_`weight'-tavg_`bin'_2C_3C_`weight')

	* positive values
	foreach i of numlist 3(5)28 {
		loc lb = `i'
		loc lbplus = `lb'+1
		loc ub = `i'+ 5
		loc ubminus = `ub' -1
		egen `bin'_`lb'C_`ub'C_`weight' = rowtotal(tavg_`bin'_`lb'C_`lbplus'C_`weight' - tavg_`bin'_`ubminus'C_`ub'C_`weight')
		}
		
	* top bin
	egen `bin'_33C_Inf_`weight' = rowtotal(tavg_`bin'_33C_34C_`weight' - tavg_`bin'_35C_Inf_`weight')
	}
}
****

**** Create bins (pop weighted) with cutoffs that correspond roughly to 10F intervals
local weight "pop"
egen bin1 = rowtotal(tavg_bin_nInf_n40C_`weight'-tavg_bin_n13C_n12C_`weight')
egen bin2 = rowtotal(tavg_bin_n12C_n11C_`weight'-tavg_bin_n7C_n6C_`weight')
egen bin3 = rowtotal(tavg_bin_n6C_n5C_`weight'-tavg_bin_n2C_n1C_`weight')
egen bin4 = rowtotal(tavg_bin_n1C_0C_`weight'-tavg_bin_4C_5C_`weight')
egen bin5 = rowtotal(tavg_bin_5C_6C_`weight'-tavg_bin_9C_10C_`weight')
egen bin6 = rowtotal(tavg_bin_10C_11C_`weight'-tavg_bin_14C_15C_`weight')
egen bin7 = rowtotal(tavg_bin_15C_16C_`weight'-tavg_bin_20C_21C_`weight')
egen bin8 = rowtotal(tavg_bin_21C_22C_`weight'-tavg_bin_25C_26C_`weight')
egen bin9 = rowtotal(tavg_bin_26C_27C_`weight'-tavg_bin_31C_32C_`weight')
egen bin10 = rowtotal(tavg_bin_32C_33C_`weight'-tavg_bin_35C_Inf_`weight')

**** Save
save "`cntryDir'/`clim'_tempbins_with_13month_formerge.dta", replace
****

  * Done *
*************
}



local cntry "ind"
local cntryDir ``cntry'Dir'
local adminVar ``cntry'Var'

cap mkdir "`cntryDir'/dta"

* Bottom bin cutoff
local realbot = -40
local top = 35
local mid = -1
local inc = 1
local bot = -34

**** Save as .dta
forvalues i = `bot'(`inc')`top' {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			
				local cutoffs "n`lo'C_n`hi'C"

		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	*local cutoffs = subinstr("`cutoffs'","-","",.)
	import delimited "`cntryDir'/csv/`clim'_tavg_BIN_`cutoffs'.csv", case(preserve) encoding("latin1") clear
	duplicates drop `adminVar' year, force
	save "`cntryDir'/dta/`clim'_tavg_BIN_`cutoffs'.dta", replace
}
****

**** Combine monthly bins into annual
local init = 1
local arealist
local poplist
local croplist
local arealist13
local poplist13
local croplist13
forvalues i = `bot'(`inc')`top' {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {

				local cutoffs "n`lo'C_n`hi'C"

		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	*local cutoffs = shiinstr("`cutoffs'","-","",.)
	if `init' {
	use "`cntryDir'/dta/`clim'_tavg_BIN_`cutoffs'.dta", clear
	local init = 0
	}
	else {
	merge 1:1 `adminVar' year using "`cntryDir'/dta/`clim'_tavg_BIN_`cutoffs'.dta", nogen
	}
	foreach weight in area pop crop {
	local bin "tavg_bin_`cutoffs'_`weight'"
	egen `bin' = rowtotal(tavg_bin_`cutoffs'_m*_`weight')
	local `weight'list ``weight'list' `bin'
	
	egen admin_unit = group(`adminVar')
	xtset admin_unit year
	local bin13 "tavg_bin13_`cutoffs'_`weight'"
	gen `bin13' = `bin' + L.tavg_bin_`cutoffs'_m12_`weight'
	replace `bin13' = `bin' if `bin13' == .
	xtset, clear
	drop admin_unit
	local `weight'list13 ``weight'list13' `bin13'
	
	drop *_m*_`weight'
	}
}

order year `adminVar' `poplist' `arealist' `croplist' `poplist13' `arealist13' `croplist13'
****

**** Create 5C bins
local top = 35
local mid = -1
local inc = 1
local bot = -41
foreach bin in bin bin13 {
	foreach weight in area pop crop {
	
	local binlist
	forvalues i = -41(1)35 {
	* Low and high cutoffs
	local lo = abs(`i')
	local hi = abs(`i'+1)
	*local inext = `i' + 1
	* Convert cutoff to string for use in the variable names
	if `i' == `mid' {
		local cutoffs = "n`lo'C_`hi'C"
	}
	else {
		if `i' < 0 {
			if `i' == `bot' {
				local cutoffs "nInf_n`hi'C"
			}
			else {
				local cutoffs "n`lo'C_n`hi'C"
			}
		}
		else {
			if `i' == `top' {
				local cutoffs "`lo'C_Inf"
			}
			else {
				local cutoffs "`lo'C_`hi'C"
			}
		}
	}
	cap gen tavg_`bin'_`cutoffs'_`weight' = 0
	local binvar tavg_`bin'_`cutoffs'_`weight'
	local binlist `binlist' `binvar'
	}
	
	order `binlist'
	
	* bottom bin
	egen `bin'_nInf_n17C_`weight' = rowtotal(tavg_`bin'_nInf_n40C_`weight'-tavg_`bin'_n18C_n17C_`weight')

	* negative values
	foreach i of numlist 12 7 2 {
		loc lb = `i'+5 
		loc lbplus = `lb'-1 
		loc ub = `i'
		loc ubminus = `ub' +1
		egen `bin'_n`lb'C_n`ub'C_`weight' = rowtotal(tavg_`bin'_n`lb'C_n`lbplus'C_`weight' - tavg_`bin'_n`ubminus'C_n`ub'C_`weight')
		}

	* crossing zero
	egen `bin'_n2C_3C_`weight' = rowtotal(tavg_`bin'_n2C_n1C_`weight'-tavg_`bin'_2C_3C_`weight')

	* positive values
	foreach i of numlist 3(5)28 {
		loc lb = `i'
		loc lbplus = `lb'+1
		loc ub = `i'+ 5
		loc ubminus = `ub' -1
		egen `bin'_`lb'C_`ub'C_`weight' = rowtotal(tavg_`bin'_`lb'C_`lbplus'C_`weight' - tavg_`bin'_`ubminus'C_`ub'C_`weight')
		}
		
	* top bin
	egen `bin'_33C_Inf_`weight' = rowtotal(tavg_`bin'_33C_34C_`weight' - tavg_`bin'_35C_Inf_`weight')
	}
}
****

**** Create bins (pop weighted) with cutoffs that correspond roughly to 10F intervals
local weight "pop"
egen bin1 = rowtotal(tavg_bin_nInf_n40C_`weight'-tavg_bin_n13C_n12C_`weight')
egen bin2 = rowtotal(tavg_bin_n12C_n11C_`weight'-tavg_bin_n7C_n6C_`weight')
egen bin3 = rowtotal(tavg_bin_n6C_n5C_`weight'-tavg_bin_n2C_n1C_`weight')
egen bin4 = rowtotal(tavg_bin_n1C_0C_`weight'-tavg_bin_4C_5C_`weight')
egen bin5 = rowtotal(tavg_bin_5C_6C_`weight'-tavg_bin_9C_10C_`weight')
egen bin6 = rowtotal(tavg_bin_10C_11C_`weight'-tavg_bin_14C_15C_`weight')
egen bin7 = rowtotal(tavg_bin_15C_16C_`weight'-tavg_bin_20C_21C_`weight')
egen bin8 = rowtotal(tavg_bin_21C_22C_`weight'-tavg_bin_25C_26C_`weight')
egen bin9 = rowtotal(tavg_bin_26C_27C_`weight'-tavg_bin_31C_32C_`weight')
egen bin10 = rowtotal(tavg_bin_32C_33C_`weight'-tavg_bin_35C_Inf_`weight')

**** Save
save "`cntryDir'/`clim'_tempbins_formerge.dta", replace
****

  * Done *
*************

*/
