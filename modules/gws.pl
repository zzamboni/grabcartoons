$COMIC{gws} = {
		Title => 'Girls with Slingshots',
		Page => 'http://www.girlswithslingshots.com/',
		Regex => qr!src="({Page}comics/.*?)"!i,
		ExtraImgAttrsRegex => qr!src="{Page}comics.*?".*(title=".*?")!i,
	       };
