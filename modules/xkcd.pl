$COMIC{xkcd} = {
		Title => 'xkcd',
		Page => 'http://xkcd.com/',
		Regex => qr!img[^<>]*src="(http://imgs\.xkcd\.com/comics.*?)"!i,
	       };
