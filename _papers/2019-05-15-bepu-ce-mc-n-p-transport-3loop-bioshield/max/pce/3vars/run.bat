rem Run DAKOTA
dakota -i hb2.in -o hb2.out > screen.out
	
rem Generate diagnostic report
rscript generateReport.R 
