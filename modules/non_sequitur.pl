sub get_url_non_sequitur {
    my $base="http://www.non-sequitur.com/";
    my $page="$base";
    my $title="Non Sequitur";
    fetch_url($page)
      or return(undef, $page, $title);
    while (get_line()) {
	if (/img src="(.*\/comics\/nq\/.+?\.gif)"/i) {
        return($1, $page, $title);
    }
  }
  $@="Couldn not find image in $title page";
  return (undef, $base, $title);

}

1;
