$COMIC{gws} = {
		Title => 'Girls with Slingshots',
		Page => 'http://www.girlswithslingshots.com/',
		Regex => qr!src="(http://[^/]*?/comics/.*?)"!i,
		ExtraImgAttrsRegex => qr!src="http://[^/]*?/comics/.*?".*?(title=".*?")!i,
	       };
