$COMIC{errantstory} = {
		Title => 'Errant Story',
		Page => 'http://www.errantstory.com/',
		Regex => qr!src="({Page}comics/.*?)"!i,
		TitleRegex => qr!src="\{Page}comics.*?".*title="(.*?)"!i,
		ExtraImgAttrsRegex => qr!src="\{Page}comics.*?".*(title=".*?")!i,
	       };
