$COMIC{extraordinary} = {
    Title => 'Extra Ordinary',
    Page => 'http://exocomics.com/',
    Regex => qr!img +src="(.+?)".*class="comic-item!i,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
};
