$COMIC{achewood} = {
		    'Title' => 'Achewood',
		    'Page' => 'http://www.achewood.com',
                    #'Regex' => qr!img src="((http://m.assetbar.com/achewood/[^"]*)?(/|%2F)comic.php(\?|%3F)date(=|%3D)[^"]*)"!,
                    'Regex' => qr!img src="([^"]*comic.php[^"]*)" title=!,
		    'ExtraImgAttrsRegex' => qr!img src="[^"]*comic.php[^"]*" (title="[^"]*")!,
		    'NoShowTitle' => 1,
                    #'Prepend' => '{Page}',
                   };
