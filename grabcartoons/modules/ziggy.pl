# Contributed by Bill Huff
sub get_url_ziggy {
  my $base="http://www.ucomics.com";
  my $page="$base/ziggy/";
  my $title="Ziggy";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src=\".*(images\.ucomics\.com/comics/zi/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}

1;
