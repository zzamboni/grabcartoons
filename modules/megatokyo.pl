sub get_url_megatokyo {
  my $mtbase="http://www.megatokyo.com";
  my $mtpage="$mtbase/index.php";
  my $title="MegaTokyo";
  fetch_url($mtpage)
    or return (undef, $mtpage, $title);
  while (get_line()) {
    if (/IMG SRC="\/(strips\/\d+\.(gif|jpg))"/) {
	return ("$mtbase/$1", $mtpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $mtpage, $title);
}


1;
