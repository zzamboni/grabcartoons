# http://www.ucomics.com/thefifthwave/viewfw.htm
sub get_url_fifth_wave {
  my $fwbase="http://www.ucomics.com";
  my $fwpage="$fwbase/thefifthwave/index.phtml";
  my $title="The 5th Wave";
  fetch_url($fwpage)
    or return (undef, $fwpage, $title);
  while (get_line()) {
    if (/img src="http:[^\"]*(images.ucomics.com\/comics\/fw\/\d+\/fw\d+.gif)"/) {
	return ("http://$1", $fwpage, $title);
    }
  }
  $err="Could not find image in The 5th Waves's page";
  return (undef, $fwpage, $title);
}


1;
