# Contributed by Ben Kuperman

sub get_url_irregular2 {
  my $irregbase="http://www.irregularwebcomic.net";
  my $irregpage=$irregbase."/";
  my $title="Irregular Webcomic";
  fetch_url($irregpage)
  #fetch_url("http://www.irregularwebcomic.net/cgi-bin/comic.pl?comic=805")
    or return (undef, $irregbase, $title);
  my $block = "";
  while (get_line()) {
    if (/(<img src="(\/comics\/\w+\.(jpg|gif))" WIDTH=\d+ HEIGHT=\d+[^>]*>)/i) {
	my $line=$1;
	$line =~ s/"\/comics/"$irregbase\/comics/i;
	$block .= $line;
	$block .= "<br></a>";
	# Find the annotation
	my $annote=0;
	while (get_line()) {
	   if (/^\[<a href.*show me annotations/i) {
	     $block .= "<a href=\"$irregbase\">";
	     last;
	   } 
	   if (/<\/div>/) {
	     $annote=1;
	     next;
	   }
	   if (1 == $annote) {
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
