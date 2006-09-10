sub get_url_xkcd {
  my $base="http://xkcd.com";
  my $page="$base/";
  my $title="xkcd";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!URL for this image:\s+(\S+)</h3>!i) {
	return ("$1", $page, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $page, $title);
}

1;
