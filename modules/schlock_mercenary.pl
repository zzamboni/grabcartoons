$COMIC{schlock_mercenary} = {
    Title => 'Schlock Mercenary',
    Base => 'http://www.schlockmercenary.com/',
    Page => '{Base}',
    StartRegex => qr(\<div id='comic'),
    EndRegex => qr(\</div\>|\<!--AIO_END--\>),
    SubstOnRegexResult => [ [ qr(src="/comics), 'src="{Base}comics', 1 ] ],
};
