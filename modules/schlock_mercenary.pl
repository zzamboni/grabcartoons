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
      if (/.*<!--startcomic-->(.*)<!--endcomic-->/i) {
	($retval = $1) =~ s!(SRC=")(/comics[^"]*")!$1$schlockbase$2!ig;
	  return("\" width=0 height=0 >".$retval."<a href=\"$schlockbase\"><img width=0 height=0 src=\"", $schlockpage, $title);
      }
      if (/(.*\/comics\/.*)/i) {
	($retval = $1) =~ s!(SRC=")(/comics[^"]*")!$1$schlockbase$2!ig;
	  return("\" width=0 height=0 >".$retval."<a href=\"$schlockbase\"><img width=0 height=0 src=\"", $schlockpage, $title);
      }
  }

  $@="Couldn not find image in $title page";
  return (undef, $schlockpage, $title);
}

1;
