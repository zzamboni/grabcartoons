$COMIC{machall} = {
		   Title => 'MacHall',
		   Page => 'http://www.machall.com/',
		   Regex => qr!img src="(comics/\d+\.jpg)"!,
		   Prepend => '{Page}',
		   'NoShowTitle' => 1,
		  };
