$COMIC{joy_of_tech} = {
    Title => 'The Joy of Tech',
    Page => 'http://www.joyoftech.com/joyoftech/',
    Regex => qr/src="[^"]*(joyimages\/[^"]*(?<!banner)\.(?:gif|png|jpg))"/,
    ExtraImgAttrsRegex => qr/(alt="[^"]*")/,
    Prepend => '{Page}',
    NoShowTitle => 1,
};
