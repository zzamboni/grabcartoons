# Contributed by Ben Kuperman

sub get_url_diesel_sweeties {
  my $dsbase="http://www.dieselsweeties.com";
  my $dspage=$dsbase."/index.php";
  my $title="Diesel Sweeties";
  my $cmd="$WGET $dspage";
  open CMD, "$cmd |" or do {
    $@="Error executing $cmd: $!";
    return (undef, $dsbase, $title);
  };
  while (<CMD>) {
    if (/<img src="(http:\/\/images.clango.org\/strips\/sw\d+.(png|gif))" border="0" alt="newest cartoon">/i) {
        return($1, $dsbase, $title);
    }
  }
  $@="Could not find image in Diesel Sweeties' page";
  return (undef, $dsbase, $title);
}

1;
