sub get_url_concerned {
  my $base="http://hlcomic.com";
  my $page="$base/";
  my $title="Concerned";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src="(comics/.*.)"!i) {
	return ("$base/$1", $page, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $page, $title);
}

1;
