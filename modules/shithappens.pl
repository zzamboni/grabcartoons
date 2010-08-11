$COMIC{shithappens} = {
			     Title => 'Shit Happens',
			     Page => 'http://www.ruthe.de/',
			     Regex => qr(img\s+src="(cartoons/.*?\.(jpg|png|gif|jpeg))")i,
			     Prepend => '{Page}',
			    };
