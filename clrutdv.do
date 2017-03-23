clear all
set obs 3
gen rut in 1 = 16610515
replace rut in 2 = 7620571
replace rut in 3 = 17697552


program define rutdv
syntax varname [if] [in]
marksample touse

quietly {
	// Crear copia string de variable
	tempvar var
	gen `var' = `varlist' if `touse'
	tostring `var', replace

	// Extraer largo maximo de los rut
	local N : type `var'
	local N = subinstr("`N'","str","",.)

	// Generar tempavrs con digitos del rut en orden inverso
	forvalues i = 1/`N' {
		tempvar digit_`i'
		gen `digit_`i'' = substr(`var',-`i',1) if `touse'
	}
	destring `digit*', replace

	// Multiplicar cada digito por mod(i,6)+2
	forvalues i = 1/`N' {
		replace `digit_`i'' = `digit_`i'' * `= mod(`=`i'-1',6)+2'
	}

	// Generar suma de digitos
	tempvar suma
	egen `suma' = rowtotal(`digit_1'-`digit_`N'')

	// Ultimas transformaciones
	gen dv = 11-mod(`suma',11)
	tostring dv, replace
	replace dv = "0" if dv == "11"
	replace dv = "K" if dv == "10"
}
end


rutdv rut
