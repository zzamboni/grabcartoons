# Contributed by Ben Kuperman

sub get_url_helen {
  my $helenbase="http://www.comicspage.com/helen";
  my $helenpage=$helenbase."/main.html";
  my $title="Helen";
  my $cmd="$WGET $helenpage";
  open CMD, "$cmd |" or do {
    $@="Error executing $cmd: $!";
    return (undef, $helenbase, $title);
  };
  while (<CMD>) {
    if (/<!--LATESTIMAGE--><img src="(.*\/daily\/cshln\/.*\.gif)">/i) {
        return($1, $helenbase, $title);
    }
  }
  $@="Couldn not find image in Helen's page";
  return (undef, $helenbase, $title);
}

1;
