sub get_url_achewood {
  my $awbase="http://www.achewood.com";
  my $awpage="$awbase/index.php";
  my $title="Achewood";
  fetch_url($awpage)
    or return (undef, $awpage, $title);
  while (get_line()) {
    if (/img src="(\/comic.php\?date=\d{8})"/) {
	return ($awbase.$1, $awpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $awpage, $title);
}


1;
