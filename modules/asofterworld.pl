$COMIC{asofterworld} = {
    Title => 'A Softer World',
    Base => 'http://www.asofterworld.com',
    Page => '{Base}/',
    StartRegex => qr(\<div id="comicimg"\>),
    Regex => qr!src="(.*?(?:png|jpg|gif|jpeg))"!i,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
}
