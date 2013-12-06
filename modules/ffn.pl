$COMIC{ffn} = {
    Title => 'Full Frontal Nerdity',
    Page => 'http://ffn.nodwick.com',
    Regex => qr!img src="(?:http://ffn.nodwick.com)/(ffnstrips/.*\.(?:png|gif|jpeg|jpg))"!i,
    Prepend => '{Page}/',
    NoShowTitle => 1,
};
