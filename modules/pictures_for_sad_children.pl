$COMIC{pictures_for_sad_children} = {
		    'Title' => 'Pictures for Sad Children',
		    'Page' => 'http://www.picturesforsadchildren.com',
		    'Regex' => qr!img src="(http://www\.picturesforsadchildren\.com/comics/[^"]*)"!,
		    'ExtraImgAttrsRegex' => qr!img src="http://www\.picturesforsadchildren\.com/comics/[^"]*" (title="[^"]*")!,
		    'NoShowTitle' => 0,
                   };
