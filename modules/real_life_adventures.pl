sub get_url_real_life_adventures {
  my $base="http://www.ucomics.com";
  my $page="$base/reallifeadventures/";
  my $title="Real Life Adventures";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src=\".*(images\.ucomics\.com/comics/rl/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}

1;
