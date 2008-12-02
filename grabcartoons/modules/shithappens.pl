$COMIC{shithappens} = {
			     Title => 'Shit Happens',
			     Page => 'http://www.ruthe.de/frontend/',
			     Regex => qr(img\s+src="(cartoons/.*?\.jpg)")i,
			     Prepend => '{Page}',
			    };
