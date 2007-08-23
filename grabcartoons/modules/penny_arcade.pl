$COMIC{penny_arcade} = {
			Title => 'Penny Arcade',
			Base => 'http://www.penny-arcade.com',
			Page => '{Base}/comic',
			Regex => qr@src="(/images/\d{4}/\d{8}(.)?\.(gif|jpg))"@i,
			TitleRegex => qr@<div id="comicheader">(.+)</div>@i,
			Prepend => '{Base}',
		       };
