/*
____________________________________________

Qiyue Wang
____________________________________________
*/

* Load dataset
use "path_to_your_dataset.dta", clear

* Quick look at the data
describe

* Generate a variable to indicate observations during the pandemic
gen covid_dum = (year >= 2020)
replace covid_dum = 1 if year >= 2020
label variable covid_dum "COVID-19 Indicator"
label define covid_label 0 "Before COVID-19" 1 "During/After COVID-19"
label values covid_dum covid_label

* Descriptive statistics
summ online_expendshare disp_income covid_dum internet urbanpop age gas_price, d
summ online_expendshare disp_income, detail

* Correlations among variables
corr disp_income covid_dum internet urbanpop age gas_price

* Correlation matrix graph
graph matrix disp_income covid_dum internet urbanpop age gas_price, half

* Scatter plots with fitted lines
foreach var of varlist disp_income covid_dum internet urbanpop age gas_price {
    scatter online_expendshare `var' || lfit online_expendshare `var'
}

* Regression analysis

* Main Regression
eststo clear
eststo model_main: reg online_expendshare disp_income covid_dum internet urbanpop age gas_price

* Supplementary Regression 1
eststo clear
eststo model_sup1: reg online_expendshare disp_income covid_dum internet urbanpop gas_price

* Supplementary Regression 2
eststo clear
eststo model_sup2: reg online_expendshare disp_income covid_dum internet age

* Export summary statistics to LaTeX
estpost summarize online_expendshare disp_income covid_dum internet urbanpop age gas_price
esttab using "summary_statistics.tex", replace ///
    cells("N Mean Min Max p50 SD") ///
    label title("Table 1: Summary Statistics") ///
    nomtitle nonumbers

* Export main regression results to LaTeX
esttab model_main using "regression_result_main.tex", replace ///
    cells(b(star fmt(3)) se(fmt(3))) ///
    label title("Table 2: Main Regression Result") ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonumbers

* Appendix

* Export correlation table to LaTeX
estpost corr disp_income covid_dum internet urbanpop age gas_price
esttab using "correlation_table.tex", replace ///
    cells(mean(fmt(2))) ///
    label title("Table 3: Correlation Matrix") ///
    nomtitles nonumbers
	
* Export supplementary reg results to LaTeX
esttab model_sup1 model_sup2 using "regression_results_sup.tex", replace ///
    cells(b(star fmt(3)) se(fmt(3))) ///
    label title("Table 4: Supplementary Regression Results") ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitles nonumbers

* Save results
save "path_to_save_your_results.dta", replace
