while (<>) {
  if (/                             (\d\.\d+?-?E\+\d+)  (\d\.\d+?-?E\+\d+)/) {
	print "$1\n";
  }    
}