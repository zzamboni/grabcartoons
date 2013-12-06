$COMIC{goblins} = {
    Title => 'Goblins',
    Page => 'http://www.goblinscomic.org',
    Regex => qr!img src="(?:http://www.goblinscomic.org)?([^"]*?/comics/[^"]*?(?:gif|png|jpg|jpeg))"!i,
    Prepend => '{Page}/',
    #StartRegex => qr(\<div id="comic"\>),
    #EndRegex => qr(\</div\>),
    #SubstOnRegexResult => [ [ qr(src="/comics), 'src="{Page}/comics', 1 ] ],
};
