$COMIC{achewood} = {
		    'Title' => 'Achewood',
		    'Page' => 'http://www.achewood.com',
		    'Regex' => qr!img[^<>]*src="(/comic.php\?date=[^"]*)"!,
		    'NoShowTitle' => 1,
                    'Prepend' => '{Page}',
                   };
