# Contributed by Bill Huff
sub get_url_dick_tracy {
    my $base="http://www.ucomics.com";
    my $page="$base/dicktracy/";
    my $title="Dick Tracy";
    fetch_url($page)
      or return (undef, $page, $title);
    while (get_line()) {
        if (m!src=\".*(images\.ucomics\.com/comics/tmdic/.*\.(jpg|gif))!i) {
            return ("http://$1", $page, $title);
        }
    }
    $err="Could not find image in ${title}'s page";
    return (undef, $page, $title);
}

1;
