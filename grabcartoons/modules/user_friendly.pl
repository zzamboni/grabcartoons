sub get_url_user_friendly {
  my $ufbase="http://www.userfriendly.org";
  my $ufpage="$ufbase/static/";
  my $title="User Friendly";
  fetch_url($ufpage)
    or return (undef, $ufpage, $title);
  while (get_line()) {
    if (/Latest.*SRC\s*=\s*"(.*\/cartoons\/.*?\.gif)"/i) { #'
	return ($1, $ufpage, $title);
    }
  }
  $err="Could not find image in User Friendly's page";
  return (undef, $ufpage, $title);
}


1;
