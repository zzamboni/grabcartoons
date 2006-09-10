sub get_url_smbc {
  my $base="http://www.smbc-comics.com";
  my $page="$base/";
  my $title="Saturday Morning Breakfast Cereal";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!alt="comic" src="(/comics.*.gif)"!i) {
	return ("$base$1", $page, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $page, $title);
}

1;
