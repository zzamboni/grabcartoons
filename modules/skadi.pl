$COMIC{skadi} = {
    Title => 'Skadi',
    Page => 'http://skadicomic.com/',
    Regex => qr!src=["'].*/(comics/[^'"]*.(?:gif|png|jpg|jpeg))["']!i,
    ExtraImgAttrsRegex => qr!(title=".*?")!i,
    Prepend => '{Page}',
};
