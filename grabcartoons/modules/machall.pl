sub get_url_machall {
  my $mhbase="http://www.machall.com";
  my $mhpage="$mhbase/index.php";
  my $title="MacHall";
  fetch_url($mhpage)
    or return (undef, $mhpage, $title);
  while (get_line()) {
    if (/img src='\/(index.php\?do_command=show_strip\&strip_id=\d+\&auth=\d+-\d+-\d+-\d+-\d+)'/) {
	return ("$mhbase/$1", $mhpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $mhpage, $title);
}


1;
