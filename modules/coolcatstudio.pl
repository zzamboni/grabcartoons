sub get_url_coolcatstudio {
  my $base="http://www.coolcatstudio.com";
  my $page="$base/";
  my $title="CoolCat Studio";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m@src="(/comics/.*\.gif)"@i) {
	return ("$base/$1", $page, $title);
    }
  }
  $err="Could not find image in $title's page";
  return (undef, $page, $title);
}


1;
