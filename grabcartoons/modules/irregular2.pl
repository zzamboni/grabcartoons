# Contributed by Ben Kuperman

sub get_url_irregular2 {
  my $irregbase="http://www.irregularwebcomic.net";
  my $irregpage=$irregbase."/";
  my $title="Irregular Webcomic";
  fetch_url($irregpage)
  #fetch_url("http://www.irregularwebcomic.net/cgi-bin/comic.pl?comic=805")
    or return (undef, $irregbase, $title);
  my $block = "";
#print "searching\n";
  while (get_line()) {
    if (/(<img src="(\/comics\/\w+\.(jpg|gif))" WIDTH=\d+ HEIGHT=\d+[^>]*>)/i) {
#print "Found comic\n";
	my $line=$1;
	$line =~ s/"\/comics/"$irregbase\/comics/i;
	$block .= $line;
	$block .= "<br></a>";
	# Find the annotation
	my $annote=0;
	while (get_line()) {
#print "In this: $_\n";
	   #if (/^Options.*\[\s*Annotations/i) {
	   if (/^<table cellpadding=2 cellspacing=0 border=1 align="center">$/i) {
#print "Done\n";
	     $block .= "<a href=\"$irregbase\">";
	     last;
	   } 
	   if (/<\/div>/) {
#print "Starting annotation\n";
	     $annote=1;
	     next;
	   }
	   if (1 == $annote) {
#print "adding\n";
	     $block .= $_;
	   }
	}
        return(undef, $irregpage, $title, $block);
    }
  }
  $@="Couldn not find image in $title page";
  return (undef, $irregbase, $title);
}

1;
