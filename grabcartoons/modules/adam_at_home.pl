sub get_url_adam_at_home {
    my $base="http://www.ucomics.com";
    my $page="$base/adamathome/";
    my $title="Adam @ Home";
    fetch_url($page)
      or return (undef, $page, $title);
    while (get_line()) {
        if (m!src=\".*(images\.ucomics\.com/comics/ad/.*\.(jpg|gif))!i) {
            return ("http://$1", $page, $title);
        }
    }
    $err="Could not find image in ${title}'s page";
    return (undef, $page, $title);
}

1;
