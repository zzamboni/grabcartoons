sub get_url_phd {
  my $phdbase="http://www.phdcomics.com";
  my $phdpage="$phdbase/comics.php";
  my $title="Piled Higher and Deeper";
  fetch_url($phdpage)
    or return (undef, $phdpage, $title);
  while (get_line()) {
    if (/src=(http:\/\/www.phdcomic(s)?.com\/)?(comics\/archive\/[^.]+\.gif)/) {
	return ($phdbase."/$3", $phdpage, $title);
    }
  }
  $err="Could not find image in PHD's page";
  return (undef, $phdpage, $title);
}


1;
