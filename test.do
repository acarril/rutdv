cd C:/ado/personal/rutdv

clear all
discard
set obs 3
gen rut = .
replace rut in 1 = 16610515
replace rut in 2 = 7620571
replace rut in 3 = 17697552

gen lala = .



rutdv rut, gen(lala)
