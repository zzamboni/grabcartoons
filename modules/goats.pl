$COMIC{goats} = {
    Title => 'Goats',
    Page => 'http://goats.com',
    StartRegex => qr(\<div id="comic"),
    Regex => qr/img src="(.*?)"/i,
};
