$COMIC{schlock_mercenary} = {
    Title => 'Schlock Mercenary',
    Base => 'http://www.schlockmercenary.com/',
    Page => '{Base}',
    StartRegex => qr(\<td class="Comic"),
    EndRegex => qr(\</td\>|\<!--AIO_END--\>),
    SubstOnRegexResult => [ [ qr(src="/comics), 'src="{Base}comics', 1 ] ],
};
