sub get_url_little_gamers {
  my $lgbase="http://www.little-gamers.com";
  my $lgpage="$lgbase/index.gamer";
  my $title="Little Gamers";
  my $cmd="$WGET $lgpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $lgpage, $title);
  };
  while (<CMD>) {
    if (/img border="0" src="(comics\/\d+\.gif)"/) {
	return ("$lgbase/$1", $lgpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $lgpage, $title);
}


1;
