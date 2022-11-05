$COMIC{penny_arcade} = {
			Title => 'Penny Arcade',
			Base => 'https://www.penny-arcade.com',
			Page => '{Base}/comic',
			StartRegex => qr@<a id="comic-panels" class="three-panel" >@,
			EndRegex => qr@</a>@,
			SubstOnRegexResult => [
			    [ qr@srcset=".*alt=""@, 'width="30%" alt=""', 1 ],
			    [ qr@<div class="comic-panel">@, '', 1 ],
			    [ qr@</div>@, '', 1 ]
			],
			TitleRegex => qr@<title>Penny Arcade - Comic -\s+(.+)</title>@i,
		       };
