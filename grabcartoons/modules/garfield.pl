sub get_url_garfield {
  my $base="http://www.ucomics.com";
  my $page="$base/garfield/";
  my $title="Garfield";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src=\".*(images\.ucomics\.com/comics/ga/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}

1;
