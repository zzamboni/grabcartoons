$COMIC{campcomic} = {
    Title => 'Camp Weedonwantcha',
    Base => 'http://campcomic.com',
    Page => '{Base}/comic',
    StartRegex => qr(\<div id="comic"\>),
    EndRegex => qr(\</div\>),
    Regex => qr!img +src="((.+?)/comics/(.+?))"!i,
    #SubstOnRegexResult => [ [ qr(src="/comics), 'src="{Page}/comics', 1 ] ],
};
