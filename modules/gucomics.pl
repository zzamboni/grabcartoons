sub get_url_gucomics {
  my $gubase="http://gucomics.everlore.com";
  my $gupage="$gubase/default.asp";
  my $title="/GU";
  my $cmd="$WGET $gupage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $gupage, $title);
  };
  while (<CMD>) {
    if (/src="(\/strip\/\d+\/gu_[0-9]+\.jpg)"/) {
	return ($gubase."$1", $gupage, $title);
    }
  }
  $err="Could not find image in GUComics' page";
  return (undef, $gupage, $title);
}


1;
