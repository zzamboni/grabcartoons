sub get_url_joy_of_tech {
    my $base="http://www.geekculture.com/joyoftech/";
    my $page="$base";
    my $title="The Joy of Tech";
    fetch_url($page)
	or return (undef, $page, $title);
    while (get_line()) {
	if (/src="(joyimages\/\d+\.(?:gif|png))"/) {
	return ($base."$1", $page, $title);
    }
  }
  $err="Could not find image in The Joy of Tech's page";
  return (undef, $page, $title);
}


1;
