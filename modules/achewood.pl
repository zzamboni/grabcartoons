sub get_url_achewood {
  my $awbase="http://www.achewood.com";
  my $awpage="$awbase/index.html";
  my $title="Achewood";
  fetch_url($awpage)
    or return (undef, $awpage, $title);
  while (get_line()) {
    if (/img src="(\/i\/\d{8}.gif)"/) {
	return ($awbase.$1, $awpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $awpage, $title);
}


1;
