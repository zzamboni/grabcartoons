sub get_url_alien_loves_predator {
    my $base="http://alienlovespredator.com";
    my $page="index.php";
    my $title="Alien Loves Predator";
    fetch_url("$base/$page") or return (undef, "$base/$page", $title);

    while (get_line()) {
	if (m/src=\"(.*?strips.*?\.jpg)\"/i) {
	    $url = "$1";
	    return ("$url", "$base/$page", $title);
   	}
    }

    # If you get here we didn't find an image
    $err="Could not find image in ${title}'s page";
    return (undef, "$base/$page", $title);
}

1;
