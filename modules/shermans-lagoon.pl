$COMIC{sherman} = {
        Title => "Sherman's Lagoon",
        Page => 'http://shermanslagoon.com',
        Regex => qr!IMG SRC="(.*?)".*end of #comicpanel!i,
        #Prepend => '{Base}/',
};
