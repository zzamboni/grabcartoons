$COMIC{cowandboy} = {
    Title => 'Cow and Boy',
    Page => 'http://www.cowandboy.com/',
    Regex => qr!<img src="(.*\.gif)".*title=".*">!i,
    TitleRegex => qr!img[^<>]*title="(.*)"!i,
    ExtraImgAttrsRegex => qr!img[^<>]*(alt=".*")!i,
    Prepend => '{Page}',
}
