sub get_url_penny_arcade {
  my $base="http://www.penny-arcade.com";
  my $page="$base/view.php3";
  my $title="Penny Arcade";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m@src="(images/\d{4}/\d{8}.\.(gif|jpg))"@i) {
	return ("$base/$1", $page, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $page, $title);
}


1;
