sub get_url_calvin_and_hobbes {
  my $base="http://www.ucomics.com";
  my $page="$base/calvinandhobbes/";
  my $title="Calvin and Hobbes";
  my $cmd="$WGET $page";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $page, $title);
  };
  while (<CMD>) {
    if (m!src=\".*(images\.ucomics\.com/comics/ch/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $page, $title);
}


1;
