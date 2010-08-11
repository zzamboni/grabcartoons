$COMIC{erfworld} = {
			     Title => 'Erfworld',
			     Page => 'http://www.giantitp.com',
			     Function => \&get_url_erfworld,
			    };

sub get_url_erfworld {
  my $erfbase="http://www.giantitp.com";
  my $erfpage="$erfbase/comics/erflatest.html";
  my $title="Erfworld";
  my $erflast="leer";
  fetch_url($erfpage)
    or return (undef, $erfpage, $title);
  while (get_line()) {
    if (/window\.location="\/comics(\/erf.*\.html)"/) {
        $erflast="$erfbase/comics$1";
    }
  }
  fetch_url($erflast)
    or return (undef, $erfpage, $title);
  while (get_line()) {
      if (/IMG src="\/comics\/(images\/.*\.(gif|png|jpg))"/) {
	return ("<img SRC=\"$erfbase/comics/$1\" alt=\"Today's $title\"><br>", $title, undef);
    }
  }
  $err="Could not find image in $title"."'s page";
   return ($tmp, $title, $err);
}
