sub get_url_chugworth {
    my $base="http://www.chugworth.com";
    my $page="comic.php";
    my $title="Chugworth Academy";
    fetch_url("$base/$page") or return (undef, "$base/$page", $title);

    while (get_line()) {
	if (m@src='(comic/.*?\.jpg)'@i) {
	    $url = "$1";
	    return ("$base/$url", "$base/$page", $title);
   	}
    }

    # If you get here we didn't find an image
    $err="Could not find image in ${title}'s page";
    return (undef, "$base/$page", $title);
}

1;
