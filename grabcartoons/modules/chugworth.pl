$COMIC{chugworth} = {
		     'Title' => 'Chugworth Academy',
		     'Base' => 'http://www.chugworth.com',
		     'Page' => '{Base}/comic.php',
		     'Regex' => qr(src='(comic/.*?\.jpg)'),
		     'Prepend' => '{Base}/',
		    };
