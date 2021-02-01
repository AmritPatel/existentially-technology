$count = 0;
$flag = 0;

while(<>) {
	if (($count+1) % 16 == 0) {
		if ($flag == 0) {
			push @improvement, $_;
			$flag = 1;
		}
		elsif ($flag == 1) {
			push @maxN,        $_;
			$flag = 0;
		}
	}
	
	$count++;
}

open(MAX, ">maxN.out");
print MAX @maxN;
close(MAX);

open(IMP, ">improvement.out");
print IMP @improvement;
close(IMP);
