$COMIC{schlock_mercenary} = {
			     Title => 'Schlock Mercenary',
			     Page => 'http://www.schlockmercenary.com/',
			     Function => \&get_url_schlock_mercenary,
			    };

# Contributed by Ben Kuperman
sub get_url_schlock_mercenary {
  my $schlockbase="http://www.schlockmercenary.com";
  my $schlockpage=$schlockbase."/";
  my $title="Schlock Mercenary";
  fetch_url($schlockpage)
    or return (undef, $schlockpage, $title);
  my $block = "";
  while (get_line()) {
    if (/^.*(<img\s+src\s*="\/comics\/.*\.(jpg|jpeg|gif|png)\"\s*>)/i) {
      my $tmp = $1;
      $tmp =~ s/>/ alt="Today's $title">/gi;
      $block.="$tmp<br>";
    }
  }
  if ( $block =~ /img/i ) {
    $block=~s/SRC="/SRC="$schlockbase/gi;
    return ($block, $title, undef);
  }

  $err="Could not find image in $title page";
  return (undef, $title, $err);
}
