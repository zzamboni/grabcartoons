$COMIC{extraordinary} = {
    Title => 'Extra Ordinary',
    Page => 'http://www.exocomics.com/',
    StartRegex => qr!<a id="comic-\d+" class="comic">!,
    EndRegex => qr!</a>!,
    InclusiveCapture => 0,
    SubstOnRegexResult => [ 
        [ qr(class="[^"]*"), '', 1 ],
        [ qr(alt="[^"]*"), '', 1 ],
        [ qr([\s_]+), ' ', 1 ],
    ],
};
