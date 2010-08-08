$COMIC{oots} = {
    Title => 'Order of the Stick',
    Page => 'http://www.giantitp.com',
    Function => \&get_url_oots,
};

sub get_url_oots {
  my $ootsbase="http://www.giantitp.com";
  my $ootspage="$ootsbase/comics/ootslatest.html";
  my $title="Order of the Stick";
  my $ootslast="leer";
  fetch_url($ootspage)
    or return (undef, $ootspage, $title);
  while (get_line()) {
    if (/window\.location="\/comics(\/oots.*\.html)"/) {
        $ootslast="$ootsbase/comics$1";
    }
  }
  fetch_url($ootslast)
    or return (undef, $ootspage, $title);
  while (get_line()) {
      if (/IMG src="\/comics\/(images\/.*\.(gif|png|jpg))"/) {
	return ("<img SRC=\"$ootsbase/comics/$1\" alt=\"Today's $title\"><br>", $title, undef);
    }
  }
  $err="Could not find image in $title"."'s page";
   return ($tmp, $title, $err);
}
