sub get_url_angst_technology {
  my $inkbase="http://www.inktank.com";
  my $inkpage="$inkbase/AT/index.cfm";
  my $title="Angst Technology";
  fetch_url($inkpage)
    or return (undef, $inkpage, $title);
  while (get_line()) {
    if (/SRC="(\/images\/AT\/cartoons\/\d\d-\d\d-\d\d\.gif)"/) {
	return ($inkbase."$1", $inkpage, $title);
    }
  }
  $err="Could not find image in inktank's page";
  return (undef, $inkpage, $title);
}


1;
