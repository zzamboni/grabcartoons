sub get_url_choppingblock {
  my $cbbase="http://www.choppingblock.org";
  my $cbpage="$cbbase/index.html";
  my $title="ChoppingBlock";
  fetch_url($cbpage)
    or return (undef, $cbpage, $title);
  while (get_line()) {
    if (/IMG ALT="" BORDER=0 SRC="\/(comics\/cb\d+\.(gif|jpg))"/) {
	return ("$cbbase/$1", $cbpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $cbpage, $title);
}


1;
