sub get_url_dilbert {
  my $dilbase="http://www.unitedmedia.com";
  my $dilpage="$dilbase/comics/dilbert/";
  my $title="Dilbert";
  fetch_url($dilpage)
    or return (undef, $dilpage, $title);
  while (get_line()) {
    if (/SRC="([\w.\/]+\.gif)[^<>]*ALT="today's Dilbert comic/i) { #'
	return ($dilbase.$1, $dilpage, $title);
    }
  }
  $err="Could not find image in Dilbert's page";
  return (undef, $dilpage, $title);
}


1;
