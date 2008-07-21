$COMIC{atland} = {
    Title => 'Atland',
    Page => 'http://www.realmofatland.com',
    Regex => qr(img src="(images\/strips\/atland\d+\.jpg)")i,
    Prepend => '{Page}/',
};
