sub get_url_bizarro {
    my $base="http://www.kingfeatures.com/";
    my $page="${base}features/comics/bizarro/about.htm";
    my $page2="${base}features/comics/bizarro/aboutMaina.php";
    my $title="Bizarro";
    fetch_url($page2)
      or return (undef, $page, $title);
    while (get_line()) {
        if (m!src='(http://est.rbma.com/content/Bizarro\?date=\d{8})'!i) {
            return ($1, $page, $title);
        }
    }
    $err="Could not find image in ${title}'s page";
    return (undef, $page, $title);
}
1;
