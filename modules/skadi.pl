$COMIC{skadi} = {
    Title => 'Skadi',
    Page => 'http://skadicomic.com/',
    StartRegex => qr(<div id="comic">),
    Regex => qr!src=["']([^'"]*.(?:gif|png|jpg|jpeg))["']!i,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
    #Prepend => '{Page}',
};
