sub get_url_non_sequitur {
    my $base="http://www.non-sequitur.com/";
    my $page="$base";
    my $title="Non Sequitur";
    # Fixed URL, but fetch the page anyway
    fetch_url($page)
      or return(undef, $page, $title);
    return ('http://www.non-sequitur.com/today.php3', $page, $title);
}

1;
