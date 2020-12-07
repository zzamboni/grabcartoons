$COMIC{formalsweatpants} = {
    Title => 'Formal Sweatpants',
    Base => 'http://formalsweatpants.com',
    Page => '{Base}/',
    RedirectMatch => qr!{Base}/comic/!,
    RedirectURLCapture => qr!href="({Base}/comic/.*?)"!,
    StartRegex => qr(\<div.*the-content"\>),
    EndRegex => qr(\</div\>),
    Regex => qr!img src="(.*?)"!i,
}
