sub get_url_rose_is_rose {
  my $rosebase="http://www.unitedmedia.com";
  my $rosepage="$rosebase/comics/roseisrose/";
  my $title="Rose is Rose";
  fetch_url($rosepage)
    or return (undef, $rosepage, $title);
  while (get_line()) {
    if (/SRC\s*=\s*"(.*?images\/roseisrose.*?\.(gif|jpg))"/i) {
	return ($rosebase.$1, $rosepage, $title);
    }
  }
  $err="Could not find image in Rose is Rose's page";
  return (undef, $rosepage, $title);
}


1;
