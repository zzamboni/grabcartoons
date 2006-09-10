sub get_url_wondermark {
  my $base="http://www.wondermark.com";
  my $page="$base/";
  my $title="Wondermark";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src="(/comics/.*\.gif)"!i) {
	return ("$base$1", $page, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $page, $title);
}

1;
