
$COMIC{whatsnormalanyway}={
        Title	=> 'What\'s Normal Anyway?',
        Page	=> 'http://whatsnormalanyway.net/',
        Regex	=> qr(<img src="(http:\/\/whatsnormalanyway.net\/comics\/[^\"]*?\.(?:png|gif|jpg|jpeg))"[^>]*title="[^"]*")i,
        ExtraImgAttrsRegex => qr!src=".*/comics/.*\.(?:gif|png|jpg|jpeg)".*(alt=.*title=".*?")!i,
    };

