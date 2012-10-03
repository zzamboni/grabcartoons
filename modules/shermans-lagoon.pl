$COMIC{sherman} = {
        Title => "Sherman's Lagoon",
        Base => 'http://www.slagoon.com',
        Page => '{Base}/cgi-bin/sviewer.pl',
        Regex => qr!IMG SRC="(dailies/SL\d+.gif)"!i,
        Prepend => '{Base}/',
};
