$COMIC{powernap} = {
    Title => 'Power Nap',
    Base => 'http://www.powernapcomic.com',
    Page => '{Base}/',
    StartRegex => qr(tabla en blanco con comic aqui) ,
    EndRegex => qr(del comic),
    InclusiveCapture => 0,
    Regex => qr!<img src="(.*)</td>!i,
    #Regex => qr!(?:img src=")?(?:http://www.powernapcomic.com)?(.*?\.(gif|png|jpg|jpeg))"!i,
    #Prepend => '{Page}',
}
