# Contributed by Ben Kuperman
# recommended by Rob Balder <PClips@aol.com>

sub get_url_partiallyclips {
  my $pclipsbase="http://www.partiallyclips.com";
  my $pclipspage=$pclipsbase."/index.php\?b=1";
  my $title="PartiallyClips";
  fetch_url($pclipspage)
    or return (undef, $pclipsbase, $title);
  while (get_line()) {
    if (/IMG SRC="($pclipsbase.*\/storage\/.*\.(gif|png|jpg))" border="0" Title="Click for larger version"/i) {
        return($1, $pclipspage, $title);
    }
  }
  $@="Couldn not find image in PartiallyClips's page";
  return (undef, $pclipsbase, $title);
}

1;
