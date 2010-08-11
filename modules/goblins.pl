$COMIC{goblins} = {
    Title => 'Goblins',
    Page => 'http://goblinscomic.com',
    StartRegex => qr(\<div id="comic"\>),
    EndRegex => qr(\</div\>),
    SubstOnRegexResult => [ [ qr(src="/comics), 'src="{Page}/comics', 1 ] ],
};
