sub get_url_rose_is_rose {
  my $rosebase="http://www.unitedmedia.com";
  my $rosepage="$rosebase/comics/roseisrose/";
  my $title="Rose is Rose";
  my $cmd="$WGET $rosepage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $rosepage, $title);
  };
  while (<CMD>) {
    if (/SRC\s*=\s*"(.*?images\/roseisrose.*?\.gif)"/i) {
	return ($rosebase.$1, $rosepage, $title);
    }
  }
  $err="Could not find image in Rose is Rose's page";
  return (undef, $rosepage, $title);
}


1;
