$COMIC{achewood} = {
		    'Title' => 'Achewood',
		    'Page' => 'http://www.achewood.com',
		    'Regex' => qr!img src="(http://m\.assetbar\.com/[^"]*)"!,
		    'ExtraImgAttrsRegex' => qr!img src="http://m\.assetbar\.com/[^"]*" (title="[^"]*")!,
		    'NoShowTitle' => 1,
                   };
