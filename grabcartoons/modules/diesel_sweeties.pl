# Contributed by Ben Kuperman

sub get_url_diesel_sweeties {
  my $dsbase="http://www.dieselsweeties.com/";
  my $dspage=$dsbase."index.php";
  my $title="Diesel Sweeties";
  fetch_url($dspage)
    or return (undef, $dsbase, $title);
  while (get_line()) {
    if (/<img src="(\/hstrips\/.*\/\d+.(png|gif))" border="0" alt="newest cartoon">/i) {
        return("$dsbase$1", $dsbase, $title);
    }
  }
  $@="Could not find image in Diesel Sweeties' page";
  return (undef, $dsbase, $title);
}

1;
