$COMIC{savage_chickens} = {
    Title => 'Savage Chickens',
    Page => 'http://www.savagechickens.com/',
    NoShowTitle => 1,
    StartRegex => qr(div class="entry_content")i,
    EndRegex => qr(div class="clear"),
    InclusiveCapture => 0,
}
