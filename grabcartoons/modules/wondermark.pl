$COMIC{wondermark} = {
		      Title => 'Wondermark',
		      Page => 'http://www.wondermark.com/',
		      Regex => qr!src="/(comics/.*\.gif)"!i,
		      Prepend => '{Page}',
		      NoShowTitle => 1,
		     };
