sub get_url_jenny_jetpack {
    my $base="http://www.comicssherpa.com";
    my $page="$base/site/feature?uc_comic=csymr";
    my $title="Jenny Jetpack";
    fetch_url($page)
	or return (undef, $page, $title);
    while (get_line()) {
	if (m@img src="(http://images.ucomics.com/comics/csymr/.*.gif)@) {
	    return ($1, $page, $title);
	}
    }
    $err="Could not find image in Jenny Jetpack's page";
    return (undef, $page, $title);
}

1;
