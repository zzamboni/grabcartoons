sub get_url_achewood {
  my $awbase="http://www.achewood.com";
  my $awpage="$awbase/index.html";
  my $title="Achewood";
  my $cmd="$WGET $awpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $awpage, $title);
  };
  while (<CMD>) {
    if (/img src="(\/i\/\d{8}.gif)"/) {
	return ("$awbase/$1", $awpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $awpage, $title);
}


1;
