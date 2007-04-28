$COMIC{xkcd} = {
		Title => 'xkcd',
		Page => 'http://xkcd.com/',
		Regex => qr!URL for this image:\s+(\S+)</h3>!i,
	       };
