$COMIC{formalsweatpants} = {
    Title => 'Formal Sweatpants',
    Base => 'http://formalsweatpants.com',
    Page => '{Base}/',
    StartRegex => qr(\<div id="comic"\>),
    Regex => qr!img src="(.*?)"!i,
}
