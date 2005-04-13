# Contributed by Ben Kuperman

# http://www.purdueexponent.org/comics/
sub get_url_exponent {
  my $exponentbase="http://www.purdueexponent.org";
  my $exponentpage=$exponentbase."/comics/";
  my $title="Purdue Exponent";
  fetch_url($exponentpage)
    or return (undef, $exponentpage, $title);
#  my $retstring=get_fullpage();
  my $block="";
  while (get_line()) {
      if (/^(<img\s+src\s*=.*\.(jpg|jpeg|gif|png)\s*><br>$)/i) {
	my $line="$1";
	if ($line =~ /SRC=\//i) {
	    $line =~ s/SRC=\//SRC=$exponentbase\//i;
	 } else {
	    $line =~ s/SRC=/SRC=$exponentpage/i;
	 }
	    
	$block.="$line";
      }
  }
  if ( $block =~ /img/i ) {
      #$block=~s/<br>//;
      $block=~s/SRC="/SRC="$exponentbase/gi;
      return (undef, $exponentpage, $title, $block);
    }

  $@="Couldn not find image in $title page";
  return (undef, $exponentpage, $title);
}

1;
