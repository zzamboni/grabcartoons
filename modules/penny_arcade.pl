$COMIC{penny_arcade} = {
			Title => 'Penny Arcade',
			Base => 'http://www.penny-arcade.com',
			Page => '{Base}/comic',
                        #Regex => qr@src="(http://art.penny-arcade.com/photos/[^\"]*?\.(gif|jpg))"@i,
			Regex => qr@src="(http://[^/]*penny-arcade[^/]*/photos/[^\"]*?\.(gif|jpg))"@i,
                        TitleRegex => qr@<title>Penny Arcade! -\s+(.+)</title>@i,
		       };
