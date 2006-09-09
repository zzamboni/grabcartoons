sub get_url_mother_goose {
  my $base="http://www.grimmy.com";
  my $page="$base/comics.php";
  my $title="Mother Goose & Grimm";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src="(http://www\.grimmy\.com/images/MGG_Archive/.*?\.gif)!i) {
	return ($1, $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}

1;
