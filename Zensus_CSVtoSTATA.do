* 1) 100x100m
cd "C:\Users\backesne\Desktop\ZENSUS 2022"
global datain "C:\Users\backesne\Desktop\ZENSUS 2022\100m-Gitter"
global dataout "C:\Users\backesne\Desktop\ZENSUS 2022\100m-Gitter\Stata"

* info: 7 nicht auf 100m verfügbar

foreach i of numlist 1/42 {
  if `i' != 7 {
    import delimited "$datain\\`i'_100m.csv", clear
      capture confirm variable werterlaeuternde_zeichen
    if _rc == 0 {
        rename werterlaeuternde_zeichen werterlaeuternde_zeichen_`i'
    }
    save "$dataout\\`i'_100m.dta", replace
}
}



* in 1 Datensatz Zusammenführen

clear 

/*
* 1. Alle IDs sammeln
** Schritt kann man sich auch sparen, war nur um sicherzugehen, dass keine ID übersehen wird, aber es gibt Datensätze, die die Maximalliste enthalten; zB 3

tempfile all_ids
* Start mit erster Datei
use gitter_id_100m using "$dataout\\1_100m.dta", clear
duplicates drop
save `all_ids', replace
forvalues i = 1/42 {
	  if `i' != 7 {
    use gitter_id_100m using "$dataout\\`i'_100m.dta", clear
    duplicates drop
    append using `all_ids', force
    duplicates drop
    save `all_ids', replace
}
}
* 2. Starte mit vollständiger ID-Liste
use `all_ids', clear

*/

use "$dataout\\3_100m.dta", clear

* 3. Merget alle Merkmalsdateien dazu
forvalues i = 1/42 {
	  if `i' != 3 & `i' != 7 {
    merge 1:1 gitter_id_100m using "$dataout\\`i'_100m.dta"
	rename _merge merge_`i'
}
}

* 4. Speichern
save "$dataout\\zensusatlass2022.dta", replace

*optional:
drop merge_*


* Variablennamen auf maximal 30 Zeichen
rename mehrere_deutsch_und_auslaendisch mehrere_deutsch_und_ausl

ds, has(type string)
local stringvars `r(varlist)'

* Variablen ausschließen, die nicht konvertiert werden sollen
local stringvars : list stringvars - gitter_id_100m

foreach var of local stringvars {
    
    * Falls es sich um eine werterläuternde Variable handelt → als Dummy verarbeiten
    if strpos("`var'", "werterlaeuternde_zeichen") {
        display "Erzeuge Dummy für Flag-Variable: `var'"
        
        gen byte `var'f = (`var' == "KLAMMER")
    }
    
    * Sonst normal konvertieren (String → Double)
    else {
        display "Verarbeite numerische String-Variable: `var'"
        replace `var' = subinstr(`var', ",", ".", .)  // Komma in Punkt umwandeln
        
        gen double `var'_n = real(`var')
        drop `var'
        rename `var'_n `var'
    }
}

drop werterlaeuternde_zeichen_1-werterlaeuternde_zeichen_34

save "$dataout\\zensusatlas2022_100m.dta", replace

* 2) 1x1km
* info: 4 gibts nicht
cd "C:\Users\backesne\Desktop\ZENSUS 2022"
global datain "C:\Users\backesne\Desktop\ZENSUS 2022\1km-Gitter"
global dataout "C:\Users\backesne\Desktop\ZENSUS 2022\1km-Gitter\Stata"


foreach i of numlist 1/42 {
  if `i' != 4 {
    import delimited "$datain\\`i'_1km.csv", clear
      capture confirm variable werterlaeuternde_zeichen
    if _rc == 0 {
        rename werterlaeuternde_zeichen werterlaeuternde_zeichen_`i'
    }
    save "$dataout\\`i'_1km.dta", replace
}
}



* in 1 Datensatz Zusammenführen
* Datensatz mit max obs benutzen zB 5

clear 

use "$dataout\\5_1km.dta", clear

* 3. Merget alle Merkmalsdateien dazu
forvalues i = 1/42 {
	  if `i' != 4 & `i' != 5 {
    merge 1:1 gitter_id_1km using "$dataout\\`i'_1km.dta"
	rename _merge merge_`i'
}
}

* 4. Speichern
use "$dataout\\zensusatlass2022.dta", replace

*optional:
drop merge_*

* Variablennamen auf maximal 30 Zeichen
rename mehrere_deutsch_und_auslaendisch mehrere_deutsch_und_ausl

*Datentypen anpassen
ds, has(type string)
local stringvars `r(varlist)'

* Variable ausschließen 
local stringvars : list stringvars - gitter_id_1km

foreach var of local stringvars {
    
    * Falls es sich um eine werterläuternde Variable handelt → als Dummy verarbeiten
    if strpos("`var'", "werterlaeuternde_zeichen") {
        display "Erzeuge Dummy für Flag-Variable: `var'"
        
        gen byte `var'f = (`var' == "KLAMMER")
    }
    
    * Sonst normal konvertieren (String → Double)
    else {
        display "Verarbeite numerische String-Variable: `var'"
        replace `var' = subinstr(`var', ",", ".", .)  // Komma in Punkt umwandeln
        
        gen double `var'_n = real(`var')
        drop `var'
        rename `var'_n `var'
    }
}

drop werterlaeuternde_zeichen_1-werterlaeuternde_zeichen_34

save "$dataout\\zensusatlas2022_1km.dta", replace

