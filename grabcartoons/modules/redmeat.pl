
sub get_url_redmeat {
  my $rmbase="http://www.redmeat.com/redmeat/current";
  my $rmpage="$rmbase/index.html";
  my $title="Red Meat";
  my $cmd="$WGET $rmpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $rmpage, $title);
  };
  while (<CMD>) {
    if (/img src="(.*\.gif)" width="\d\d\d" height="\d\d\d" alt="" border="0"/) {
	return ("$rmbase/$1", $rmpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $rmpage, $title);
}


1;
