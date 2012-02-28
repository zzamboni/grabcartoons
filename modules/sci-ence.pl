$COMIC{'sci-ence'} = {
		Title => 'sci-ence',
		Page => 'http://sci-ence.org/',
		Regex => qr!img[^<>]*src="(http://sci-ence\.org/comics/.*?)"!i,
		TitleRegex => qr!comicpane.*title="(.*?)"!i,
	       };
