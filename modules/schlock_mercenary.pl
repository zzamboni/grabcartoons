# Contributed by Ben Kuperman

sub get_url_schlock_mercenary {
  my $schlockbase="http://www.schlockmercenary.com";
  my $schlockpage=$schlockbase."/";
  #my $schlockpage="http://www.schlockmercenary.com/d/20040118.html";
  my $title="Schlock Mercenary";
  fetch_url($schlockpage)
    or return (undef, $schlockpage, $title);
  #my $retstring=get_fullpage();
  #$retstring =~ s/\s+/ /g;
  while (get_line()) {
      if (/^(.*\/comics\/.*)/i) {
	$block=$1;
	$block=~s/<br>//;
	$block=~s/SRC="/SRC="$schlockbase/gi;
	return (undef, $schlockpage, $title, $block);
      }
  }

  $@="Couldn not find image in $title page";
  return (undef, $schlockpage, $title);
}

1;
