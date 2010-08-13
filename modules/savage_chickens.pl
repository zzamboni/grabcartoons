$COMIC{savage_chickens} = {
    Title => 'Savage Chickens',
    Page => 'http://www.savagechickens.com/',
    NoShowTitle => 1,
    StartRegex => qr(img src="http://(www.)?savagechickens.com/images/.*alt="Savage Chickens -)i,
    EndRegex => qr(div class="postmeta"),
    InclusiveCapture => 1,
    SubstOnRegexResult => [ [ qr(\<div class="postmeta"\>), ""],
			    [ qr(\<p\>), "" ], [ qr(\<\/p\>), "</a>" ] ],
}
