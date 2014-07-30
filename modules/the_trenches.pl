$COMIC{the_trenches} = {
        Title => 'The Trenches',
        Page => 'http://trenchescomic.com',
        Regex => qr@src="(http://[^/]*penny-arcade[^/]*/photos/[^\"]*?\.(?:gif|png|jpeg|jpg))"@i,
        TitleRegex => qr@<title>The Trenches -\s+(.+)</title>@i,
        ExtraImgAttrsRegex => qr@(alt=".*?")@i,
        };
