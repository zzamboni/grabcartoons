sub get_url_phd {
  my $phdbase="http://phd.stanford.edu";
  my $phdpage="$phdbase/comics.cfm";
  my $title="Piled Higher and Deeper";
  my $cmd="$WGET $phdpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $phdpage, $title);
  };
  while (<CMD>) {
    if (/src="(archive\/[^.]+\.gif)"/) {
	return ($phdbase."/$1", $phdpage, $title);
    }
  }
  $err="Could not find image in PHD's page";
  return (undef, $phdpage, $title);
}


1;
