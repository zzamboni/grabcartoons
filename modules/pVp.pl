# Contributed by Scott Baker
sub get_url_pvp {
  my $base="http://www.pvponline.com/";
  my $url="www.pvponline.com/";
  my $page="$base";
  my $title="pVp";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src=\".*(archive\/200.?\/(.*\.gif))!i) {
	return ("http://$url/$1", $page, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $page, $title);
}

1;
