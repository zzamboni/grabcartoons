sub get_url_sluggy_freelance {
  my $sfbase="http://www.sluggy.com";
  my $sfpage="$sfbase";
  my $title="Sluggy Freelance";
  fetch_url($sfpage)
    or return (undef, $sfpage, $title);
  while (get_line()) {
    if (/SRC\s*=\s*"(.*\/comics\/.*?\.(gif|jpg))"/i) { #'
	return ($1, $sfpage, $title);
    }
  }
  $err="Could not find image in ${title}'s page";
  return (undef, $sfpage, $title);
}


1;
