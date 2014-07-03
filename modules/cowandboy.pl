$COMIC{cowandboy} = {
    Title => 'Cow and Boy',
    Page => 'http://www.cowandboy.com/',
    StartRegex => '<div id="comic">',
    Regex => qr!<img src="(cb\d*\.(?:gif|png|jpg|jpeg))"(?:[^>]*title=".*">)?!i,
    #TitleRegex => qr!img[^<>]*title="(.*)"!i,
    #ExtraImgAttrsRegex => qr!img[^<>]*(alt=".*")!i,
    Prepend => '{Page}',
}
