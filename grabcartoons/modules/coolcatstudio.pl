sub get_url_coolcatstudio {
  my $base="http://www.coolcatstudio.com";
  my $page="$base/";
  my $title="CoolCat Studio";
  my $cmd="$WGET $page";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $page, $title);
  };
  while (<CMD>) {
    if (m@src="(/comics/.*\.gif)"@i) {
	return ("$base/$1", $page, $title);
    }
  }
  $err="Could not find image in $title's page";
  return (undef, $page, $title);
}


1;
