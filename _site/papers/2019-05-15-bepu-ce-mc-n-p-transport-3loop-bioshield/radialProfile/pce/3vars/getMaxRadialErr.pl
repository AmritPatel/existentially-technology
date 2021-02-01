while (<>) {
  if (/                             (\d\.\d+?-?E\+\d+)  (\d\.\d+?-?E\+\d+)/) {
	print "$2\n";
  }    
}