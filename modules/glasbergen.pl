sub get_url_glasbergen {
    my $base="http://www.glasbergen.com";
    my $page="$base";
    my $title="Glasbergen";
    # Fixed URL, but grab the page anyway
    fetch_url($page)
      or return(undef, $page, $title);
    return ("$base/images/toon.gif", $page, $title);
}

1;
