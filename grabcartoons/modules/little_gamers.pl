sub get_url_little_gamers {
  my $lgbase="http://www.little-gamers.com";
  my $lgpage="$lgbase/index.gamer";
  my $title="Little Gamers";
  fetch_url($lgpage)
    or return (undef, $lgpage, $title);
  while (get_line()) {
    if (/img border="0" src="(comics\/\d+\.gif)"/) {
	return ("$lgbase/$1", $lgpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $lgpage, $title);
}


1;
