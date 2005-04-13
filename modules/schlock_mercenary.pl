# Contributed by Ben Kuperman

sub get_url_schlock_mercenary {
  my $schlockbase="http://www.schlockmercenary.com";
  my $schlockpage=$schlockbase."/";
  #my $schlockpage="http://www.schlockmercenary.com/d/20040118.html";
  #my $schlockpage="http://www.schlockmercenary.com/d/20050402.html";
  my $title="Schlock Mercenary";
  fetch_url($schlockpage)
    or return (undef, $schlockpage, $title);
  #my $retstring=get_fullpage();
  #$retstring =~ s/\s+/ /g;
  my $block = "";
  while (get_line()) {
      if (/^.*(<img\s+src\s*="\/comics\/.*\.(jpg|jpeg|gif|png)\"\s*>)/i) {
	$block.="$1<br>";
      }
  }
  if ( $block =~ /img/i ) {
      #$block=~s/<br>//;
      $block=~s/SRC="/SRC="$schlockbase/gi;
      return (undef, $schlockpage, $title, $block);
    }

  $@="Couldn not find image in $title page";
  return (undef, $schlockpage, $title);
}

1;
