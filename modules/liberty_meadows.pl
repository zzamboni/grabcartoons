$COMIC{liberty_meadows} = {
			   Title => 'Liberty Meadows',
			   Base => 'http://www.creators.com',
			   Page => '{Base}/comics/liberty-meadows.html',
			   Regex => qr!img src="(/comics/.*?)"!,
			   Prepend => '{Base}',
			  };
