$COMIC{gws} = {
		Title => 'Girls with Slingshots',
		Page => 'http://www.girlswithslingshots.com/',
		Regex => qr!src="((http:)?//[^/]*?/comics/.*?)"!i,
		ExtraImgAttrsRegex => qr!(title=".*?").*?src="(http:)?//[^/]*?/comics/.*?"!i,
	       };
