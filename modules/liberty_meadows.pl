sub get_url_liberty_meadows{
  my $lmpage="http://creators.com/comics_show.cfm?next=1&ComicName=lib";
  my $title="Liberty Meadows";
  fetch_url($lmpage)
    or return (undef, $lmpage, $title);
  while (get_line()) {
    if (/SRC\s*=\s*"(.*\/lib\/.*?\.(gif|jpg))"/i) { #'
	return ( "http://creators.com/$1", $lmpage, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $lmpage, $title);
}


1;
