sub get_url_choppingblock {
  my $cbbase="http://www.choppingblock.org";
  my $cbpage="$cbbase/index.html";
  my $title="ChoppingBlock";
  my $cmd="$WGET $cbpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $cbpage, $title);
  };
  while (<CMD>) {
    if (/IMG ALT="" BORDER=0 SRC="\/(comics\/cb\d+\.(gif|jpg))"/) {
	return ("$cbbase/$1", $cbpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $cbpage, $title);
}


1;
