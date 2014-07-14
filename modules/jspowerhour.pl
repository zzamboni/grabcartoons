
$COMIC{jspowerhour} = {
    Title => 'Junior Scientist Power Hour',
    Page => 'http://www.jspowerhour.com/',
    Function => \&get_url_jspowerhour,
};


sub get_url_jspowerhour {
    my $jsp_base="http://www.jspowerhour.com/";
    my $jsp_title="Junior Scientist Power Hour";
    my $jsp_comic = undef;

    fetch_url($jsp_base)
        or return (undef, $jsp_base, $jsp_title);

    # Get the comic
    while (get_line()) {
        if (/id="comic-img".*src="([^\"]*\.(?:gif|png|jpg|jpeg)[^\"]*)"/i) {
            $jsp_comic="$1";
            last;
        }
    }

    $err="Could not find image in <a href=\"$jsp_base\">$jsp_title"."</a>'s page";
    return (undef, $jsp_base, $err) unless defined $jsp_comic;

    # Get the commentary/alt text
    my $commentary="", $comic_title = undef;
    my $incommentary = 0; # haven't found it yet
    while (get_line()) {
        
        # find the start of the block
        if (/div id="description"/) {
            $incommentary = 1; # in section, keep looking
            next;
        }

        # keep looping until you find the right div
        next unless ($incommentary > 0);

        # skip other divs
        next if (/<div/);
        if (/<h1><a[^>]*>([^<]*)<\/a><\/h1>/) {
            $comic_title = $1;
            $incommentary = 2;
            next;
        }

        # skip until we find a title
        next unless ($incommentary > 1);

        # we have found the title, grab stuff until we hit a closing div
        last if (/<\/div>/);

        # concatenate it all
        $commentary .= $_;

    }

    if ($incommentary > 0) {
        return ("<img src=\"$jsp_comic\"></a><h3>$comic_title</h3><div class=\"annotation\">$commentary</div><a>", $jsp_title, undef);
    } else {
	return ("<img SRC=\"$jsp_comic\" alt=\"Today's $jsp_title\"><br>", $jsp_title, undef);
    }
}


