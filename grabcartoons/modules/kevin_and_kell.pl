sub get_url_kevin_and_kell {
  my $kkpage="http://www.kevinandkell.com/";
  my $title="Kevin and Kell";

  fetch_url($kkpage) or return (undef, $kkpage, $title);

  while (get_line()) {
    if (/.*SRC\s*=\s*"(.*\/strips\/.*?\.gif)"/i) { #'
	return ("$kkpage/$1", $kkpage, $title);
    }
  }
  $err="Could not find image in $title's page";
  return (undef, $kkpage, $title);
}


1;
