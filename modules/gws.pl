$COMIC{gws} = {
		Title => 'Girls with Slingshots',
		Page => 'http://www.girlswithslingshots.com/',
		Regex => qr!src="(http://cdn.*?/comics/.*?)"!i,
		ExtraImgAttrsRegex => qr!src="http://cdn.*?/comics/.*?".*?(title=".*?")!i,
	       };
