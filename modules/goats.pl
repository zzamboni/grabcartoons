$COMIC{goats} = {
		 Title => 'Goats',
		 Page => 'http://goats.com',
		 Regex => qr/IMG SRC="(.*?\/xgoats\d+.*?\.(?:gif|png|jpg))"/i,
                 #Prepend => '{Page}'
		};
