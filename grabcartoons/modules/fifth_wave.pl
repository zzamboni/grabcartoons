# http://www.ucomics.com/thefifthwave/viewfw.htm
sub get_url_fifth_wave {
  my $fwbase="http://www.ucomics.com";
  my $fwpage="$fwbase/thefifthwave/viewfw.htm";
  my $title="The 5th Wave";
  my $cmd="$WGET $fwpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $fwpage, $title);
  };
  while (<CMD>) {
    if (/img src="http:\/\/[^"]+(\/images.ucomics.com\/comics\/fw\/\d+\/fw\d+.gif)"/) {
	return ("http:/$1", $fwpage, $title);
    }
  }
  $err="Could not find image in The 5th Waves's page";
  return (undef, $fwpage, $title);
}


1;
