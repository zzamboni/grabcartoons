# Contributed by Ben Kuperman

sub get_url_helen {
  my $helenbase="http://www.comicspage.com/helen";
  #my $helenpage=$helenbase."/main.html";
  my $helenpage="http://www.comicspage.com/comicspage/main.jsp\\?custid=67\\&catid=1242\\&dir=/helen";
  my $title="Helen";
  my $cmd="$WGET $helenpage";
  open CMD, "$cmd |" or do {
    $@="Error executing $cmd: $!";
    return (undef, $helenbase, $title);
  };
  while (<CMD>) {
    if (m!<img src="(http://www\.tmsfeatures\.com/tmsfeatures/servlet/com\.featureserv\.util\.Download\?file=\d{8}cshln-.-.\.jpg&code=cshln)">!i) {
    #if (/<!--LATESTIMAGE--><img src="(.*\/daily\/cshln\/.*\.gif)">/i) {
        return($1, $helenbase, $title);
    }
  }
  $@="Couldn not find image in Helen's page";
  return (undef, $helenbase, $title);
}

1;
