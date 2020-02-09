$COMIC{gws} = {
		Title => 'Girls with Slingshots',
		Page => 'http://www.girlswithslingshots.com/',
		Regex => qr!src="((http(?:s)?:)?//[^/]*?/comics/.*?)"!i,
		ExtraImgAttrsRegex => qr!(title=".*?").*?src="(http(?:s)?:)?//[^/]*?/comics/.*?"!i,
	       };
