$COMIC{goblins} = {
    Title => 'Goblins',
    Page => 'http://goblinscomic.com',
    Function => \&get_url_goblins,
};

sub get_url_goblins {
  my $goblinsbase="http://goblinscomic.com";
  my $goblinspage=$goblinsbase."/index.html";
  my $title="Goblins";
#  my $goblinslast="leer";
  fetch_url($goblinspage)
    or return (undef, $goblinsbase, $title);
  my @urls=();
  my @m=();
  while (get_line()) {
    if (@m=(/SRC="(\/comics\/\d+.?\.jpg)"/g)) {
	push @urls, map { "$goblinsbase$_" } @m;
    }
  }
  if (@urls) {
      return (join('<br>', map { qq(<img src="$_">) } @urls), $title, undef);
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $title, $err);
}
