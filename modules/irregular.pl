# Contributed by Ben Kuperman

sub get_url_irregular {
  my $irregbase="http://www.irregularwebcomic.net";
  my $irregpage=$irregbase."/";
  my $title="Irregular Webcomic";
  fetch_url($irregpage)
    or return (undef, $irregbase, $title);
  while (get_line()) {
    if (/img src="(\/comics\/\w+\.(jpg|gif))" WIDTH=\d+ HEIGHT=\d+/i) {
        return($irregbase.$1, $irregpage, $title);
    }
  }
  $@="Couldn not find image in $title page";
  return (undef, $irregbase, $title);
}

1;
