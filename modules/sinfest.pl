sub get_url_sinfest {
  my $base="http://sinfest.net";
  my $page="$base/";
  my $title="Sinfest";
  my ($s,$m,$h,$dy,$mo,$yr)=localtime(time);
  fetch_url($page)
    or return(undef, $page, $title);
  while (get_line()) {
      if (m!SRC\s*=\s*\".*(/comikaze/comics/\d{4}-\d{2}-\d{2}\.gif)!i) {
          return("$base$1", $page, $title);
      }
  }
  $err="Could not find image in $title"."'s page";
  return (undef, $page, $title);
}

1;
