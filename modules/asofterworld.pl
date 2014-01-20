$COMIC{asofterworld} = {
    Title => 'A Softer World',
    Base => 'http://www.asofterworld.com',
    Page => '{Base}/',
    StartRegex => qr(\<p id="thecomic"\>),
    Regex => qr!img src="(.*?)"!i,
    #Regex => qr!img src="\_s*(.*?)"!i,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
}
