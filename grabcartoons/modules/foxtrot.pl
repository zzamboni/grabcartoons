sub get_url_foxtrot {
  my $base="http://www.ucomics.com";
  my $page="$base/foxtrot/";
  my $title="Foxtrot";
  my $cmd="$WGET $page";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $page, $title);
  };
  while (<CMD>) {
    if (m!src=\".*(images\.ucomics\.com/comics/ft/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}


1;
