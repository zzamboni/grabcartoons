sub get_url_user_friendly {
  my $ufbase="http://www.userfriendly.org";
  my $ufpage="$ufbase/static/";
  my $title="User Friendly";
  my $cmd="$WGET $ufpage";
  open CMD, "$cmd |" or do {
    $err="Error executing $cmd: $!";
    return (undef, $ufpage, $title);
  };
  while (<CMD>) {
    if (/Latest.*SRC\s*=\s*"(.*\/cartoons\/.*?\.gif)"/i) { #'
	return ($1, $ufpage, $title);
    }
  }
  $err="Could not find image in User Friendly's page";
  return (undef, $ufpage, $title);
}


1;
