sub get_url_nine_to_five {
  my $base="http://www.ucomics.com";
  my $page="$base/9to5/";
  my $title="9 to 5";
  fetch_url($page)
    or return (undef, $page, $title);
  while (get_line()) {
    if (m!src=\".*(images\.ucomics\.com/comics/tmntf/.*\.gif)!i) {
	return ("http://$1", $page, $title);
    }
  }
  $err="Could not find image in $ {title}'s page";
  return (undef, $page, $title);
}

1;
