Z:\SCALE\WIN-SCALE-6.2.3\bin\scalerte.exe hb2.inp -m > screen.out
Z:\SCALE\WIN-SCALE-6.2.3\bin\scalerte.exe mtPullN.inp
Z:\SCALE\WIN-SCALE-6.2.3\bin\scalerte.exe mtPullP.inp
rem perl getMax.pl hb2.inp > maxes.out
perl getMaxRadial.pl radialMaxN.dat >> maxes.out
perl getMaxRadialErr.pl radialMaxN.dat >> maxes.out
perl getMaxRadial.pl radialMaxP.dat >> maxes.out
perl getMaxRadialErr.pl radialMaxP.dat >> maxes.out
