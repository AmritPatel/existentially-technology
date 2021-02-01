$count = 0;

while(<>) {

	if ($count == 0) {
		push @h2oDens,     $_;
	}
	elsif ($count == 1) {
		push @concDens,    $_;
	}
	elsif ($count == 2) {
		push @linerR,      $_;
	}
	elsif ($count == 3) {
		push @improvement, $_;
	}
	elsif ($count == 7) {
		push @maxN,        $_;
		$count = -1;
	}
	
	$count++;
}

print @maxN;