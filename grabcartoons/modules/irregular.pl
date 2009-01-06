$COMIC{irregular} = {
		     Title => 'Irregular Webcomic',
		     Page => 'http://www.irregularwebcomic.net/',
		     Function => \&get_url_irregular,
		    };

# Contributed by Ben Kuperman

sub get_url_irregular {
  my $irregbase="http://www.irregularwebcomic.net";
  my $irregpage=$irregbase."/";
  my $title="Irregular Webcomic";
  fetch_url($irregpage)
    or return (undef, $irregbase, $title);
  my $block = "";
  while (get_line()) {
    if (/(<img src="(\/comics\/\w+\.(jpg|gif|png))" WIDTH="?\d+"? HEIGHT="?\d+"?[^>]*>)/i) {
      my $line=$1;
      $line =~ s/"\/comics/"$irregbase\/comics/i;
      $block .= $line;
      $block .= "<br></a>";
      # Find the annotation
      my $annote=0;
      while (get_line()) {
          if (/<div id="annotation"[^>]*>(.*)/i) {
              $block .= "<div id=\"annotation\">$1";
              $annote=1;
              next;
              #$block .= "<a href=\"$irregbase\">";
              #last;
          } 
          if (1 == $annote) {
              $block .= $_;
              if (/^<\/div>/) {
                  $annote=0;
                  last;
              }
          }
      }
      return($block, $title, undef);
    }
  }
  $err="Could not find image in $title page";
  return (undef, $title, $err);
}
