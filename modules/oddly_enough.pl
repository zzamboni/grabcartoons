sub get_url_oddly_enough {
  my $base="http://www.ucomics.com";
  my $page="$base/oddlyenough/";
  my $title="Oddly Enough";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src=\".*(images\.ucomics\.com/comics/oe/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}

1;
