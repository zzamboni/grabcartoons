# Contributed by Ben Kuperman

sub get_url_goats {
  my $goatbase="http://www.goats.com";
  my $goatpage=$goatbase."/index.html";
  my $title="Goats";
  my $cmd="$WGET $goatpage";
  open CMD, "$cmd |" or do {
    $@="Error executing $cmd: $!";
    return (undef, $goatbase, $title);
  };
  while (<CMD>) {
    if (/IMG SRC="(.*\/comix\/.*\.gif)" WIDTH=750 HEIGHT=26[0-9]/i) {
        return($goatbase.$1, $goatbase, $title);
    }
  }
  $@="Couldn not find image in Goat's page";
  return (undef, $goatbase, $title);
}

1;
