sub get_url_legostar_galactica {
  my $lgbase="http://legostargalactica.keenspace.com";
  my $lgpage="$lgbase/";
  my $title="Legostar Galactica";
  fetch_url($lgpage)
    or return (undef, $lgpage, $title);
  while (get_line()) {
    if (/img[^>]* src="(http:\/\/legostargalactica.keenspace.com\/comics\/\d+.(gif|jpg))"/i) {
	return ("$1", $lgpage, $title);
    }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $lgpage, $title);
}


1;
