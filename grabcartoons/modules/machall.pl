sub get_url_machall {
  my $mhbase="http://www.machall.com";
  my $mhpage="$mhbase/index.php";
  my $title="MacHall";
  my $cmd="$WGET $mhpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $mhpage, $title);
  };
  while (<CMD>) {
    if (/img src='\/(index.php\?do_command=show_strip\&strip_id=\d+\&auth=\d+-\d+-\d+-\d+-\d+)'/) {
	return ("$mhbase/$1", $mhpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $mhpage, $title);
}


1;
