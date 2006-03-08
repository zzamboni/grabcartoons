# Contributed by Ben Kuperman

sub get_url_goats {
  my $goatbase="http://www.goats.com";
  my $goatpage=$goatbase."/index.html";
  my $title="Goats";
  fetch_url($goatpage)
    or return (undef, $goatbase, $title);
  while (get_line()) {
    if (/IMG SRC="(.*\/comix\/.*\.(gif|png|jpg))" WIDTH=(")?\d+(")? HEIGHT=(")?\d+(")?/i) {
        return($goatbase.$1, $goatbase."/", $title);
    }
  }
  $@="Couldn not find image in Goat's page";
  return (undef, $goatbase, $title);
}

1;
