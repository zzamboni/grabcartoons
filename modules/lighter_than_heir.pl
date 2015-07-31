$COMIC{lighter_than_heir} = {
    Title => 'Lighter than Heir',
    Page => 'http://lighterthanheir.com',
    Regex => qr/src="[^"]*(comics\/[^"]*(?<!banner)\.(?:gif|png|jpg))"[^>]*id="comic"/,
    Prepend => '{Page}/',
};
