$COMIC{sufficiently_remarkable} = {
    Title => 'Sufficiently Rermarkable',
    Base => 'http://sufficientlyremarkable.com',
    Page => '{Base}/',
    StartRegex => qr(\<div class="comic"\>),
    EndRegex => qr(\</div\>),
    Regex => qr!img +src="((.+?)/comics/(.+?))"!i,
};
