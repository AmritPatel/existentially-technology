Z:\SCALE\WIN-SCALE-6.2.3\bin\scalerte.exe hb2.inp -m > screen.out
Z:\SCALE\WIN-SCALE-6.2.3\bin\scalerte.exe mtMaxN.inp
Z:\SCALE\WIN-SCALE-6.2.3\bin\scalerte.exe mtMaxP.inp
rem perl getMax.pl hb2.inp > maxes.out
rem perl getMax.pl mtMaxN.out > maxes.out
rem perl getMax.pl hb2.mt1.resp7.txt >> maxes.out
perl getMax.pl mtMaxP.out > maxes.out
rem perl getMax.pl hb2.mt2.resp8.txt >> maxes.out