$COMIC{penny_arcade} = {
			Title => 'Penny Arcade',
			Base => 'https://www.penny-arcade.com',
			Page => '{Base}/comic',
			Regex => qr@src="(http(s)?://[^/]*/comics/[^/]*[^\"]*?\.(gif|png|jpeg|jpg))"@i,
                        TitleRegex => qr@<title>Penny Arcade - Comic -\s+(.+)</title>@i,
		       };
