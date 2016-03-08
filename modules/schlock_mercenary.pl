$COMIC{schlock_mercenary} = {
    Title => 'Schlock Mercenary',
    Base => 'https://www.schlockmercenary.com/',
    Page => '{Base}',
    InclusiveCapture => 1,
    StartRegex => qr(\<div class="strip-image-wrapper"),
    EndRegex => qr(\</div\>|\<!--AIO_END--\>),
    SubstOnRegexResult => [ 
        [ qr(.*\<div class="strip-image-wrapper">), '', 1 ],
        [ qr(\<\/div\>.*), '', 1 ],
        [ qr(src="/strip), 'src="{Base}strip', 1 ],
    ],
};
